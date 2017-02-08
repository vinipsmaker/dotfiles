export PATH="$PATH:$HOME/Sistema/bin"

if [[ -z $DISPLAY && $XDG_VTNR -le 3 && $(tty) == /dev/tty* ]]; then
    #exec gnome-session --session=gnome-wayland
    #dbus-launch --exit-with-session way-cooler
    exec startx
fi
