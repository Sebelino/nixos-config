# Keyboard Layouts

This directory contains custom XKB keyboard layouts for my setup.

## Solemak (solemak)

A custom keyboard layout that remaps keys for improved typing efficiency:

- **Space key**: Functions as Right Shift
- **Tab key**: Functions as Backspace  
- **Caps Lock**: Functions as Left Control
- **Escape**: Functions as Caps Lock
- **Left Shift**: Functions as Tab
- **Right Shift**: Functions as Menu
- **AE11 (+ key)**: Functions as Super/Windows key

Letter layout follows a custom arrangement optimized for programming and typing.

## Swedish Standard (sesebel) 

A standard Swedish keyboard layout with proper Swedish characters:

- **Space key**: Functions as space (normal behavior)
- **åäö**: Available in their standard positions
- All keys function as expected on a standard Swedish keyboard
- Based on the standard `se` layout from XKB

## Layout Switching

Use the `toggle_solemak.sh` script or press **Right Control** to switch between:
- `solemak` → `sesebel` (Swedish)
- `sesebel` → `solemak` (Custom)

The active layout is managed by Sway and can be queried with:
```bash
swaymsg -t get_inputs | jq -r '.[].xkb_active_layout_name'
```

## Files

- `xkb/symbols/solemak` - Solemak custom layout definition
- `xkb/symbols/sesebel` - Swedish standard layout definition
