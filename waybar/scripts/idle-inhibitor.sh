#!/bin/bash

STATE_FILE="/tmp/waybar-hypridle-inhibitor"

# Toggle function
toggle() {
    if [ -f "$STATE_FILE" ]; then
        # Currently inhibited, turn off
        pkill -SIGUSR1 hypridle
        rm "$STATE_FILE"
    else
        # Not inhibited, turn on
        pkill -SIGUSR2 hypridle
        touch "$STATE_FILE"
    fi
}

# Status function
status() {
    if [ -f "$STATE_FILE" ]; then
        echo "{\"text\":\"󰅶\", \"tooltip\":\"Idle inhibitor: ON (hypridle paused)\", \"class\":\"activated\"}"
    else
        echo "{\"text\":\"󰾪\", \"tooltip\":\"Idle inhibitor: OFF (hypridle active)\", \"class\":\"deactivated\"}"
    fi
}

# Main
case "$1" in
    toggle)
        toggle
        ;;
    *)
        status
        ;;
esac
