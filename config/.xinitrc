#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

rescueme() {
    sleep 5s
    xrandr --output LVDS --mode 1366x768
}
#rescueme &

numlockx

#exec gnome-session
#exec startkde
#exec startxfce4
exec enlightenment_start
