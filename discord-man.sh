#!/bin/bash

LOCAL_VERSION=$(grep -oP '"version":\s*"\K[^"]+' /usr/share/discord/resources/build_info.json)

LATEST_VERSION=$(curl -s -L -o /dev/null -w "%{url_effective}" "https://discord.com/api/download?platform=linux&format=deb" | grep -oP '(?<=discord-)[^/]+(?=\.deb)')

if [ -z "$LOCAL_VERSION" ]; then 
    read -p "Discord is not installed. Do you want to install it? (y/n): " confirm
    [ "$confirm" = "y" ] || exit 1
    url="https://discord.com/api/download?platform=linux&format=deb"
    curl -L -o /tmp/discord.deb "$url"
    sudo apt install /tmp/discord.deb
else 
    if [ "$LOCAL_VERSION" != "$LATEST_VERSION" ]; then 
        echo "Version $LATEST_VERSION is available."
        read -p "Do you want to update? (y/n): " confirm
        [ "$confirm" = "y" ] || exit 1
        url="https://discord.com/api/download?platform=linux&format=deb"
        curl -L -o /tmp/discord.deb "$url"
        sudo apt install /tmp/discord.deb
    else
        echo "Discord is already up to date (version $LOCAL_VERSION)."
    fi
fi
