import os
import requests
import zipfile
import shutil
import tkinter as tk
from tkinter import filedialog, messagebox, ttk
from threading import Thread

# Define the ToolTip class
class ToolTip:
    """Creates a tooltip for a given widget."""
    def __init__(self, widget, text):
        self.widget = widget
        self.text = text
        self.tooltip_window = None
        self.widget.bind("<Enter>", self.show_tooltip)
        self.widget.bind("<Leave>", self.hide_tooltip)

    def show_tooltip(self, event):
        """Displays the tooltip."""
        if self.tooltip_window or not self.text:
            return
        x = self.widget.winfo_rootx() + 20
        y = self.widget.winfo_rooty() + self.widget.winfo_height() + 10
        self.tooltip_window = tw = tk.Toplevel(self.widget)
        tw.wm_overrideredirect(True)  # Removes window decorations
        tw.wm_geometry(f"+{x}+{y}")
        label = tk.Label(tw, text=self.text, background="yellow", relief="solid", borderwidth=1, padx=5, pady=2)
        label.pack()

    def hide_tooltip(self, event):
        """Hides the tooltip."""
        if self.tooltip_window:
            self.tooltip_window.destroy()
            self.tooltip_window = None

def find_subfolder(root_path, folder_name):
    """Recursively searches for a subfolder within a root path."""
    for root, dirs, files in os.walk(root_path):
        if folder_name in dirs:
            return os.path.join(root, folder_name)
    return None

def merge_folders(source, destination):
    """Merges the contents of the source folder into the destination folder."""
    for item in os.listdir(source):
        source_path = os.path.join(source, item)
        destination_path = os.path.join(destination, item)
        
        if os.path.isdir(source_path):
            # If the folder does not exist in the destination, copy it entirely
            if not os.path.exists(destination_path):
                shutil.copytree(source_path, destination_path)
            else:
                # Recursively merge folders
                merge_folders(source_path, destination_path)
        else:
            # If it's a file, copy and replace it in the destination
            shutil.copy2(source_path, destination_path)

def find_game_directory():
    """Detect the APB Reloaded game directory by searching for apb.exe."""
    possible_paths = [
        r"C:\Program Files (x86)\Steam\steamapps\common\APB Reloaded",
        r"C:\Program Files\Steam\steamapps\common\APB Reloaded",
    ]
    
    for path in possible_paths:
        apb_exe = os.path.join(path, "Binaries", "apb.exe")
        if os.path.isfile(apb_exe):
            return path
    return ""

def select_folder():
    """Opens a folder dialog for selecting the APB Reloaded directory."""
    folder = filedialog.askdirectory(initialdir=default_path, title="Select APB Reloaded Game Folder")
    if folder:
        folder_var.set(folder)

def download_and_extract_github_zip_async(github_url, extract_to, install_Extras, install_commands, progress_callback):
    """Async wrapper to download and extract zip files with progress updates."""
    def task():
        zip_file_path = 'apbcfg.zip'  # Temporary ZIP file name
        
        try:
            progress_callback("Checking for latest version...", 0)
            response = requests.get(github_url, stream=True)
            response.raise_for_status()

            # Calculate total size for progress
            total_size = int(response.headers.get('content-length', 0))
            if total_size == 0:
                total_size = 1  # Avoid division by zero

            downloaded = 0

            progress_callback("Downloading ZIP file from GitHub...", 10)
            with open(zip_file_path, 'wb') as file:
                for data in response.iter_content(1024):
                    downloaded += len(data)
                    file.write(data)
                    progress = (downloaded / total_size) * 50
                    progress_callback(f"Downloading... {int(progress)}%", progress)
            
            progress_callback("Extracting ZIP file...", 60)
            temp_extract_path = './temp_extract'
            with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
                zip_ref.extractall(temp_extract_path)
            
            progress_callback("Merging game files...", 80)
            for folder_name in ['APBGame', 'Engine']:
                source_folder = find_subfolder(temp_extract_path, folder_name)
                if source_folder:
                    destination_folder = os.path.join(extract_to, folder_name)
                    os.makedirs(destination_folder, exist_ok=True)
                    merge_folders(source_folder, destination_folder)

            # Handle the Extras if checked
            if install_Extras:
                Extras_folder = find_subfolder(temp_extract_path, 'Extras')
                readme_file = os.path.join(temp_extract_path, 'apbcfg', 'readme.txt')
                downloads_folder = os.path.join(os.path.expanduser('~'), 'Downloads')

                if Extras_folder:
                    nested_Extras_folder = find_subfolder(Extras_folder, 'Extras')
                    if nested_Extras_folder:
                        shutil.rmtree(nested_Extras_folder)
                    shutil.move(Extras_folder, os.path.join(downloads_folder, 'Extras'))
                if os.path.exists(readme_file):
                    shutil.move(readme_file, os.path.join(downloads_folder, 'readme.txt'))

            # Handle the "Shortened Commands" if checked
            if install_commands:
                download_and_replace_commands(extract_to, progress_callback)

            progress_callback("Installation completed!", 100)
            messagebox.showinfo("Completed", "Download and extraction completed successfully!")

        except Exception as e:
            messagebox.showerror("Error", f"An error occurred: {e}")
        finally:
            if os.path.exists(zip_file_path):
                os.remove(zip_file_path)
            if os.path.exists(temp_extract_path):
                shutil.rmtree(temp_extract_path)
            progress_callback("Cleanup completed.", 100)
    
    Thread(target=task).start()

def download_and_replace_commands(extract_to, progress_callback):
    """Downloads the 'Shortened Commands' zip and replaces Consolecommands.GER."""
    commands_zip_url = 'https://github.com/shinzerra/apb/releases/download/aaaaaaa/Commands.zip'
    zip_file_path = 'commands.zip'
    
    try:
        progress_callback("Downloading Shortened Commands...", 90)
        response = requests.get(commands_zip_url, stream=True)
        response.raise_for_status()

        # Calculate total size for progress
        total_size = int(response.headers.get('content-length', 0))
        if total_size == 0:
            total_size = 1  # Avoid division by zero

        downloaded = 0
        with open(zip_file_path, 'wb') as file:
            for data in response.iter_content(1024):
                downloaded += len(data)
                file.write(data)
                progress = (downloaded / total_size) * 10 + 90
                progress_callback(f"Downloading Shortened Commands... {int(progress)}%", progress)
        
        progress_callback("Extracting Shortened Commands...", 95)
        temp_extract_path = './temp_extract_commands'
        with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
            zip_ref.extractall(temp_extract_path)

        # Find the Consolecommands.GER and replace it in the destination
        console_commands_file = find_subfolder(temp_extract_path, 'Consolecommands.GER')
        if console_commands_file:
            destination_folder = os.path.join(extract_to, 'APBGame', 'Config')
            os.makedirs(destination_folder, exist_ok=True)
            shutil.copy2(console_commands_file, os.path.join(destination_folder, 'Consolecommands.GER'))
            progress_callback("Consolecommands.GER replaced!", 98)

    except Exception as e:
        messagebox.showerror("Error", f"An error occurred while downloading or replacing commands: {e}")
    finally:
        if os.path.exists(zip_file_path):
            os.remove(zip_file_path)
        if os.path.exists(temp_extract_path):
            shutil.rmtree(temp_extract_path)

def start_download():
    folder = folder_var.get()
    if not folder:
        messagebox.showwarning("No Folder Selected", "Please select the APB Reloaded game folder.")
        return
    
    install_Extras = Extras_var.get()
    install_commands = commands_var.get()
    github_zip_url = 'https://github.com/shinzerra/apb/releases/download/apb1.0.4/apbcfg.zip'
    
    download_and_extract_github_zip_async(github_zip_url, folder, install_Extras, install_commands, update_progress)

def update_progress(message, progress):
    progress_label.config(text=message)
    progress_bar['value'] = progress
    root.update_idletasks()

# Initialize default_path by detecting the game directory
default_path = find_game_directory()

# GUI setup with progress bar
root = tk.Tk()
root.title("APB Reloaded Config Installer")
root.geometry("420x350")

folder_var = tk.StringVar(value=default_path)
Extras_var = tk.BooleanVar(value=False)
commands_var = tk.BooleanVar(value=False)

folder_label = tk.Label(root, text="Game Directory:")
folder_label.pack(pady=(20, 5))

folder_entry = tk.Entry(root, textvariable=folder_var, width=60)
folder_entry.pack(pady=5)

browse_button = tk.Button(root, text="Browse...", command=select_folder, width=15)
browse_button.pack(pady=5)

Extras_check = tk.Checkbutton(root, text="Install 'Extras' to Downloads folder", variable=Extras_var)
Extras_check.pack(pady=(10, 5))

# Tooltip with detailed information for 'Extras'
Extras_tooltip_text = "Includes:\n- Old config (with black sky, bannable)\n- Jmilo's Binds (16.8.24)\n- Pre-Sard Localisation"
ToolTip(Extras_check, Extras_tooltip_text)

# Checkbutton for 'Shortened Commands'
commands_check = tk.Checkbutton(root, text="Install Shortened Commands", variable=commands_var)
commands_check.pack(pady=(10, 5))

# Tooltip with detailed information for 'Shortened Commands'
commands_tooltip_text = """Shortened Commands include:
- /groupinvite -> /gi
- /claninvite -> /ci
- /toggleprofanityfilter -> /tpf
- /toggletimestamps -> /tsp
- /friendremove -> /fr
- /ignore -> /ign
- /groupremove -> /gr
- /groupjoin -> /gj
- /exit, /quit -> /q
- /friendadd -> /add
- /clanleave -> /cl
- /clanremove -> /cr
- /clandecline -> /cd
- /abandon -> /a (Abandon no longer possible.)
"""
ToolTip(commands_check, commands_tooltip_text)

install_button = tk.Button(root, text="Install", command=start_download, width=15)
install_button.pack(pady=5)

progress_label = tk.Label(root, text="Progress: ")
progress_label.pack(pady=5)

progress_bar = ttk.Progressbar(root, orient="horizontal", length=300, mode="determinate")
progress_bar.pack(pady=(5, 20))

root.mainloop()
