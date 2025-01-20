!/bin/sh

# compositor
picom -f &

# set default
xrandr --output DP-2 --mode 2560x1440 --rate 240 &
xrandr --dpi 96 &

# mouse input
xinput --set-prop "10" "libinput Accel Speed" -0.5 &
xinput --set-prop "10" "libinput Accel Profile Enabled" 0 1 0 &

# set lang & time
sudo timedatectl set-timezone Europe/London &
setxkbmap -layout gb &

# Start i3
exec i3
