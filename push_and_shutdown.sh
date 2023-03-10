#!/bin/env bash

PBS="~/.dotfiles/pbs/"

yes="   Git Push and Shutdown"
no="         Shutdown"

selected_option=$(echo "$yes
$no" | rofi -dmenu\
            -i\
            -p "Push before shutdown"\
            -config "$PBS/push_and_shutdown.rasi"\
            -width "80"\
            -lines 2\
            -line-margin 3\
            -line-padding 10\
            -scrollbar-width "0" )

if [ "$selected_option" == "$yes" ]; then
    xfce4-terminal -x $PBS/push_all_repos.sh;
    systemctl poweroff;
elif [ "$selected_option" == "$no" ]; then
    echo "Poweroff selected";
    systemctl poweroff;
else
    echo "No match"
    # echo "for '$selected_option' ('$yes' and '$no')"
fi