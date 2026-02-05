#!/bin/bash
MPD_HOST=~/.config/mpd/socket

# Get pywal color5 from the colors file (extract just the hex value)
COLOR5=$(grep "color5" ~/.cache/wal/colors-waybar.css | grep -oP '#[0-9A-Fa-f]{6}')

get_music_info() {
    # Check Spotify First
    if playerctl -p spotify status 2>/dev/null | grep -qi "playing"; then
        TITLE=$(playerctl -p spotify metadata title)
        ARTIST=$(playerctl -p spotify metadata artist)
        POS=$(playerctl -p spotify metadata --format "{{ duration(position) }}/{{ duration(mpris:length) }}")
        echo "{\"text\":\"$TITLE - $ARTIST  <span foreground='$COLOR5'>$POS</span>\", \"class\":\"spotify\"}"
        return
    fi

    # Check MPD
    if mpc -h "$MPD_HOST" status 2>/dev/null | grep -q "\[playing\]"; then
        TITLE=$(mpc -h "$MPD_HOST" current -f '%title%')
        ARTIST=$(mpc -h "$MPD_HOST" current -f '%artist%')
        TIME=$(mpc -h "$MPD_HOST" status | awk '/playing/ {print $3}')
        echo "{\"text\":\"$TITLE - $ARTIST  <span foreground='$COLOR5'>$TIME</span>\", \"class\":\"mpd\"}"
        return
    fi

    echo "{\"text\":\"\", \"class\":\"stopped\"}"
}

case $1 in
    toggle)
        # If Spotify is playing, toggle Spotify and ensure MPD is paused
        if playerctl -p spotify status 2>/dev/null | grep -qi "playing"; then
            playerctl -p spotify play-pause
            mpc -h "$MPD_HOST" pause
        else
            # Otherwise, toggle MPD and ensure Spotify is paused
            mpc -h "$MPD_HOST" toggle
            playerctl -p spotify pause 2>/dev/null
        fi
        ;;
    next) mpc -h "$MPD_HOST" next || playerctl next ;;
    prev) mpc -h "$MPD_HOST" prev || playerctl previous ;;
    *) get_music_info ;;
esac
