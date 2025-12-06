#!/bin/bash
# Change the above as you need
# Use "which bash" command
saved_wifi=$(nmcli connection show | grep "wifi")

selected_wifi=$(nmcli -f SSID dev wifi list | tail -n +2 | fzf | xargs)
# tail to skip the first line
# xargs to trim

# Grep the saved wifi network
saved_wifi=$(nmcli connection show | grep "$selected_wifi")

if [ "$saved_wifi" == "" ]; then
    echo "Connecting to $selected_wifi"
    read -p "Password: " password
    nmcli dev wifi connect "$selected_wifi" password "$password"
else
    echo "Connecting to $selected_wifi..."
    nmcli dev wifi connect "$selected_wifi"
fi
