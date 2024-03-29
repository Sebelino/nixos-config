#!/bin/sh

# Displays the status of my wireless connection.

IFACE="$(basename "$(readlink -f /sys/class/net/wl*)")"

iwconfig_out="$(iwconfig $IFACE)"

echo "$iwconfig_out" 2>&1 | grep -q no\ wireless\ extensions\. && {
  echo wired
  exit 0
}

essid="$(echo "$iwconfig_out" | awk -F '"' '/ESSID/ {print $2}')"
stngth="$(echo "$iwconfig_out" | awk -F '=' '/Quality/ {print $2}' | cut -d '/' -f 1)"
bars="$(expr $stngth / 10)"

case $bars in
  0)  bar='[----------]' ;;
  1)  bar='[/---------]' ;;
  2)  bar='[//--------]' ;;
  3)  bar='[///-------]' ;;
  4)  bar='[////------]' ;;
  5)  bar='[/////-----]' ;;
  6)  bar='[//////----]' ;;
  7)  bar='[///////---]' ;;
  8)  bar='[////////--]' ;;
  9)  bar='[/////////-]' ;;
  10) bar='[//////////]' ;;
  *)  bar='<fc=#FFA000>[----!!----]</fc>' ;;
esac


if [ "$essid" = "Sebelino-hotspot" ]; then
    echo $essid $bar "******************************************"
else
    echo $essid $bar
fi

exit 0
