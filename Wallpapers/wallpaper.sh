#!/bin/bash
# Wallpaper picker using Rofi + swww + pywal + kitty + swaync + cava + rmpc
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
FPS=60
TYPE="any"
DURATION=1.3
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

# Find monitor
focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

# Ensure swww-daemon is running
swww query || swww-daemon --no-cache --format xrgb

# Build a randomized rofi menu with thumbnails
menu() {
    find "$WALLPAPER_DIR" \
        -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) \
        -print0 |
    shuf -z | while IFS= read -r -d '' file; do
        base=$(basename "$file")
        name="${base%.*}"
        printf "%s\x00icon\x1f%s\n" "$name" "$file"
    done
}

main() {
    choice=$(menu | rofi \
        -dmenu \
        -config ~/.config/rofi/config-wallpaper.rasi \
        -p "Wallpaper")
    
    [[ -z "$choice" ]] && exit 0
    
    # Resolve selected wallpaper
    selected_wallpaper=$(find "$WALLPAPER_DIR" -type f -iname "$choice.*" | head -n 1)
    [[ -z "$selected_wallpaper" ]] && exit 1
    
    # Set wallpaper (animated)
    swww img -o "$focused_monitor" "$selected_wallpaper" $SWWW_PARAMS
    
    # Save active wallpaper
    cp "$selected_wallpaper" "$HOME/Pictures/active.jpg"
    
    # Generate pywal colors (with -n to skip auto-reload)
    
    wal -i "$selected_wallpaper" -n --backend wal
    # Source generated colors
    source ~/.cache/wal/colors.sh
    
    # Apply theme updates (run in background for speed)
    {
        # Update rmpc theme
        ~/.config/rmpc/update-rmpc-theme.sh
        
        # Reload swaync theme
        swaync-client --reload-css
        
        # Apply kitty theme
        cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf
        
        # Reload cava
        pkill -USR2 cava 2>/dev/null
        pkill -USR2 waybar
    } &
    
    echo "✓ Wallpaper applied: $(basename "$selected_wallpaper")"
}

main
