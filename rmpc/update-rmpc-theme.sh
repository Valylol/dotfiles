#!/usr/bin/env bash
# Script to update rmpc theme with pywal colors
# Place in ~/.config/rmpc/update-rmpc-theme.sh and chmod +x it

THEME_TEMPLATE="$HOME/.config/rmpc/themes/pywal.ron.template"
THEME_OUTPUT="$HOME/.config/rmpc/themes/pywal.ron"
COLORS_FILE="$HOME/.cache/wal/colors"

# Check if pywal colors exist
if [[ ! -f "$COLORS_FILE" ]]; then
    echo "Error: Pywal colors file not found at $COLORS_FILE"
    echo "Run 'wal -i /path/to/wallpaper' first"
    exit 1
fi

# Read colors into array
mapfile -t colors < "$COLORS_FILE"

# Start with template
cp "$THEME_TEMPLATE" "$THEME_OUTPUT"

# Replace color placeholders
for i in {0..15}; do
    if [[ -n "${colors[$i]}" ]]; then
        sed -i "s/{color$i}/${colors[$i]}/g" "$THEME_OUTPUT"
    fi
done

echo "✓ Updated rmpc theme with pywal colors"
echo "  Colors loaded from: $COLORS_FILE"
echo "  Theme written to: $THEME_OUTPUT"

# If rmpc is running and supports hot reload, it will pick up the changes
if pgrep -x rmpc > /dev/null; then
    echo "✓ rmpc is running and should hot-reload the theme"
fi
