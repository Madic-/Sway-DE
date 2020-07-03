## Adds a color picker to the desktop environment and copies the hexcode into the clipboard

color=$(grim -g "$(slurp -p -b 00000000)" - | convert - txt:- | awk 'END{print $3}')
wl-copy "$color"
notify-send "Color copied to clipboard" "$color" --icon 'color-picker'
