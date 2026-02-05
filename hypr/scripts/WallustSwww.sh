#!/bin/bash
# Modified to use pywal instead of wallust
# Define the path to the swww cache directory
cache_dir="$HOME/.cache/swww/"

# Get current focused monitor
current_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')
echo $current_monitor

# Construct the full path to the cache file
cache_file="$cache_dir$current_monitor"
echo $cache_file

# Check if the cache file exists for the current monitor output
if [ -f "$cache_file" ]; then
  # Get the wallpaper path from the cache file
  wallpaper_path=$(grep -v 'Lanczos3' "$cache_file" | head -n 1)
  echo $wallpaper_path
  
  # symlink the wallpaper to the location Rofi can access
  ln -sf "$wallpaper_path" "$HOME/.config/rofi/.current_wallpaper"
  
  # copy the wallpaper for wallpaper effects
  cp -r "$wallpaper_path" "$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"
  
  # Generate pywal colors
  wal -i "$wallpaper_path" -n --cols16
  
  # Source generated colors
  source ~/.cache/wal/colors.sh
  
  # Apply to kitty if config exists
  if [ -f ~/.cache/wal/colors-kitty.conf ]; then
    cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf
  fi
  
  # Reload swaync
  swaync-client --reload-css 2>/dev/null
  
  # Update Firefox
  pywalfox update 2>/dev/null
  
  # Update cava colors
  color1=$(awk 'match($0, /color2='\''(.*)'\''/,a) { print a[1] }' ~/.cache/wal/colors.sh)
  color2=$(awk 'match($0, /color3='\''(.*)'\''/,a) { print a[1] }' ~/.cache/wal/colors.sh)
  
  cava_config="$HOME/.config/cava/config"
  if [ -f "$cava_config" ]; then
    sed -i "s/^gradient_color_1 = .*/gradient_color_1 = $color1/" "$cava_config"
    sed -i "s/^gradient_color_2 = .*/gradient_color_2 = $color2/" "$cava_config"
    pkill -USR2 cava 2>/dev/null
  fi
  
  # Restart rmpc if running
  if pgrep -x rmpc > /dev/null; then
    pkill rmpc
    sleep 0.1
    setsid rmpc >/dev/null 2>&1 &
  fi
  
  # Save active wallpaper
  cp "$wallpaper_path" "$HOME/Pictures/active.jpg"
  
  echo "Pywal colors applied!"
fi
