if [[ -z $DISPLAY && $XDG_VTNR -le 3 && $(tty) == /dev/tty* ]]; then
    exec startx
fi
