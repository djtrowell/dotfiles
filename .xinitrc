#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Sets cursor properties
xsetroot -cursor_name left_ptr

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# Enables Multihead

xrandr --output HDMI-1-0 --mode 1920x1080 --rate 74.97 --primary  --output eDP1 --auto --right-of HDMI-1-0

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

conky &
dunst &
nitrogen --restore &
numlockx &
picom --vsync --experimental-backends &
unclutter &
/usr/lib/kdeconnectd &
xmobar -x 0 &
xmobar -x 1 &
exec xmonad
