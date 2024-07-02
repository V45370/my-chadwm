#!/bin/sh

#xrdb merge ~/.Xresources 
#xbacklight -set 10 &
#xset r rate 200 50 &

function run {
 if ! pgrep $1 ;
  then
    $@&
  fi
}
run "dex $HOME/.config/autostart/arcolinux-welcome-app.desktop"
#autorandr horizontal

run "nm-applet"
run "pamac-tray"
run "variety"
run "xfce4-power-manager"
run "blueberry-tray"
run "/usr/lib/xfce4/notifyd/xfce4-notifyd"
run "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
picom -b  --config ~/.config/arco-chadwm/picom/picom.conf &
run "numlockx on"
run "volumeicon"
sxhkd -c ~/.config/arco-chadwm/sxhkd/sxhkdrc &
#run "nitrogen --restore"
#you can set wallpapers in themes as well
feh --randomize --bg-fill /wallpapers/* &


#wallpaper for other Arch based systems

run "brave"
run "steam"
run "discord"

pkill bar.sh
~/.config/arco-chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
