#!/bin/sh

# Find the line in "xrandr -q --verbose" output that contains current screen orientation and "strip" out current orientation.

rotation="$(xrandr -q --verbose | grep 'connected' | egrep -o '\) (normal|left|inverted|right) \(' | egrep -o '(normal|left|inverted|right)')"

# Using current screen orientation proceed to rotate screen and input devices.

case "$rotation" in
normal)
    # rotate to the left
    xrandr -o left
    xinput set-prop 13 "Device Enabled" 0
    xinput set-prop 14 "Device Enabled" 0
    xinput set-prop 4 "Device Enabled" 0
    xsetwacom set "Wacom Pen and multitouch sensor Pen stylus	" rotate ccw
    xsetwacom set "Wacom Pen and multitouch sensor Pen eraser" rotate ccw
    xsetwacom set "Wacom Pen and multitouch sensor Finger touch" rotate ccw
    ;;
left)
    # rotate to inverted
    xrandr -o inverted
    xsetwacom set "Wacom Pen and multitouch sensor Pen stylus	" rotate half
    xsetwacom set "Wacom Pen and multitouch sensor Pen eraser" rotate half
    xsetwacom set "Wacom Pen and multitouch sensor Finger touch" rotate half
    ;;
inverted)
    # rotate to the right
    xrandr -o right
    xsetwacom set "Wacom Pen and multitouch sensor Pen stylus	" rotate cw
    xsetwacom set "Wacom Pen and multitouch sensor Pen eraser" rotate cw
    xsetwacom set "Wacom Pen and multitouch sensor Finger touch" rotate cw
    ;;
right)
    # rotate to normal
    xrandr -o normal
    xinput set-prop 13 "Device Enabled" 1
    xinput set-prop 14 "Device Enabled" 1
    xinput set-prop 4 "Device Enabled" 1
    xsetwacom set "Wacom Pen and multitouch sensor Pen stylus	" rotate none
    xsetwacom set "Wacom Pen and multitouch sensor Pen eraser" rotate none
    xsetwacom set "Wacom Pen and multitouch sensor Finger touch" rotate none
    ;;
esac
