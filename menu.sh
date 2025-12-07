#!/bin/bash
# Change the above as you need
# Use "which bash" command
saved_wifi=$(nmcli connection show | grep "wifi")

selected_wifi=$(nmcli -f SSID dev wifi list | tail -n +2 | fzf --height=10 | xargs)
# tail to skip the first line
# xargs to trim

# Grep the saved wifi network
saved_wifi=$(nmcli connection show | grep "$selected_wifi")
if [ "$selected_wifi" == "" ]; then
    echo "Invalid input!"
else
    if [ "$saved_wifi" == "" ]; then
        echo "Connecting to $selected_wifi..."
        read -p "Password: " -s password
        nmcli dev wifi connect "$selected_wifi" password "$password"
        if [ "$?" -gt 0 ]; then
            echo "Invalid password!"
            nmcli connection delete "$selected_wifi"
        fi
    else
        echo "Connecting to $selected_wifi..."
        nmcli dev wifi connect "$selected_wifi"
    fi
fi
