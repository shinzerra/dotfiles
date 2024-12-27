#!/usr/bin/env bash

# kill polybar
killall -q polybar

# launch polybar
echo "---" | tee -a /tmp/polybar.log
polybar bar 2>&1 | tee -a /tmp/polybar.log & disown
