#!/bin/bash
source ~/.cache/wal/colors.sh

sed -i \
  -e "s|^gradient_color_1.*|gradient_color_1 = '${color1}'|" \
  -e "s|^gradient_color_2.*|gradient_color_2 = '${color2}'|" \
  -e "s|^gradient_color_3.*|gradient_color_3 = '${color3}'|" \
  -e "s|^gradient_color_4.*|gradient_color_4 = '${color4}'|" \
  -e "s|^gradient_color_5.*|gradient_color_5 = '${color5}'|" \
  -e "s|^gradient_color_6.*|gradient_color_6 = '${color6}'|" \
  -e "s|^gradient_color_7.*|gradient_color_7 = '${color7}'|" \
  -e "s|^gradient_color_8.*|gradient_color_8 = '${color6}'|" \
  ~/.config/cava/config

