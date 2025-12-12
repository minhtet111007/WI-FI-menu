#!/bin/bash
# Change the above as you need
# Use "which bash" command

if [ $(nmcli networking) == "disabled" ]; then
    echo "Enable your network!"
fi

selected_wifi=$(nmcli -f SSID dev wifi list | tail -n +2 | fzf --height=10 | xargs)
saved_wifi=$(nmcli connection show | grep "$selected_wifi")

save_wifi() {
        echo "Connecting to $selected_wifi..."
        read -p "Password: " -s password
        nmcli dev wifi connect "$selected_wifi" password "$password" > /dev/null
        if [ "$?" -gt 0 ]; then
            echo "Invalid password!"
            nmcli connection delete "$selected_wifi" > /dev/null
            save_wifi
        else 
            echo "Wifi Connected!"
        fi
}

if [ "$selected_wifi" == "" ]; then
    echo "Invalid input!"
else
    if [ "$saved_wifi" == "" ]; then
        save_wifi
    else
        echo "Connecting to $selected_wifi..."
        nmcli dev wifi connect "$selected_wifi" > /dev/null
        if [ "$?" -gt 1 ]; then
            read -p "Do you want to forget and re-enter password? [y/N]" input
            if [ "$input" == "y" ]; then
                nmcli connection delete "$selected_wifi" > /dev/null
                save_wifi
            else
                echo "Can't connect to $selected_wifi"
            fi
        else
            echo "Wifi Connected!"
        fi
    fi
fi
