#!/bin/sh

# This will init DBus, among other things
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

echo ${DBUS_SESSION_BUS_ADDRESS} > ${HOME}/.dbus-last-x-session

rescueme() {
    sleep 5s
    xrandr --output LVDS --mode 1366x768
}
#rescueme &

xset b off
numlockx

#exec gnome-session
#exec startkde
#exec startxfce4
#exec enlightenment_start
exec awesome
#exec cinnamon-session
#exec cinnamon-session-cinnamon2d
#exec way-cooler
