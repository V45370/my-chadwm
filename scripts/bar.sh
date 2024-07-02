#!/bin/sh

# ^c$var^ = fg color
# ^b$var^ = bg color



interval=0

# load colors
. ~/.config/arco-chadwm/scripts/bar_themes/onedark

# cpu() {
#     cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

#     printf "^c$red^ ^b$black^󰻠"
#     printf "^c$red^ ^b$black^$cpu_val"
# }

cpu() {
    # usage=$(ps -A -o pcpu | tail -n+2 | paste -sd+ | bc | cut -d "." -f 1 | cut -d "," -f 1)
    # cores=$(nproc --all)
    # percentage=$(expr $usage / $cores)

    # printf "^c$red^ ^b$black^ 󰻠 $(expr $usage / $cores)"
	result=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1); }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat))

    printf "^c$red^ ^b$black^ 󰻠 $result"
}

# pkg_updates() {
#  updates=$(checkupdates 2>/dev/null | wc -l)   # arch

#  if [ -z "$updates" ]; then
#    printf "  ^c$green^   󰗠 "
#  else
#    printf "  ^c$yellow^    $updates"""
#  fi
# }

#battery() {
#  get_capacity="$(cat /sys/class/power_supply/BAT1/capacity)"
#  printf "^c$blue^   $get_capacity"
#}

#brightness() {
#  printf "^c$red^   "
#  printf "^c$red^%.0f\n" $(cat /sys/class/backlight/*/brightness)
#}

mem() {
    printf "^c$blue^^b$black^  "
    printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

#TODO if percentage is above 80% change to color red
hdd() {
    printf "^c$green^^b$black^ 󰋊 $(df -h / | tail -n 1 | awk '{ print $5 }')%"
}

btc_price() {
    dollar='$'
    #printf "^c$green^^b$black^ 󰠓 ${$(curl -X GET https://www.coingecko.com/price_charts/1/usd/24_hours.json | jq '.stats[length]' | sed -n "3p")%%'.'*}"
    printf "^c$orange^^b$black^ 󰠓 ^c$green^^b$black^$dollar$(curl -X GET https://api.coingecko.com/api/v3/simple/price\?ids\=bitcoin\&vs_currencies\=usd | jq '.bitcoin.usd')"
}

wlan() {
    case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
    up) printf "^c$black^^b$blue^ 󰤨 ^d^%s" " ^c$blue^ " ;;
    down) printf "^c$black^^b$blue^ 󰤭 ^d^%s" " ^c$blue^ " ;;
    esac
}

clock() {
    # printf "^c$black^ ^b$darkblue^ "
    printf "^c$black^^b$blue^$(date '+%a %d/%m/%y %H:%M:%S') "
}

get_weather() {
    apikey=$(cat ~/.config/arco-chadwm/scripts/openweather-api-key)
	#VARNA
    lat="43.2102"
    lon="27.9172"
	#SHUMEN
	#lat="43.2715"
	#lon="26.9250"

    days=2 #How many days in the future do we want a forecast for min:1 max:5

    url="http://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apikey&units=metric"

    curl -X GET $url >forecast.json
    timestamps=($(cat forecast.json | jq '.list[] | .dt'))
    temps=($(cat forecast.json | jq '.list[] | .main | .temp'))
    icons=($(cat forecast.json | jq '.list[] | .weather[0] | .icon'))
	city=($(cat forecast.json | jq '.city | .name'))

    printf "$city^c$blue^^b$black^|"
    lenght=${#temps[@]}
    dayCount=0
    for ((i = 0; i < $lenght; i++)); do

        DayHour=$(date -d @${timestamps[$i]} +"%H")
        DayOfWeek=$(date -d @${timestamps[$i]} +"%a")
        icon=""
        iconcolor=$white
        temp=${temps[$i]%%'.'*}
        tempcolor=$blue

        case ${icons[$i]} in

        '"01d"')
            icon="󰖙"
            iconcolor=$yellow
            ;;

        '"01n"')
            icon="󰖙"
            iconcolor=$yellow
            ;;

        '"02d"')
            icon="󰖕"
            iconcolor=$yellow
            ;;

        '"02n"')
            icon="󰖕"
            iconcolor=$yellow
            ;;

        '"03d"')
            icon="󰖐"
            ;;

        '"03n"')
            icon="󰖐"
            ;;

        '"04d"')
            icon="󰖐"
            ;;

        '"04n"')
            icon="󰖐"
            ;;

        '"09d"')
            icon="󰖗"
            ;;

        '"09n"')
            icon="󰖗"
            ;;

        '"10d"')
            icon="󰖗"
            ;;

        '"10n"')
            icon="󰖗"
            ;;

        '"11d"')
            icon="󰖖"
            ;;

        '"11n"')
            icon="󰖖"
            ;;

        '"13d"')
            icon="󰼶"
            ;;

        '"13n"')
            icon="󰼶"
            ;;

        '"50d"')
            icon="󰖑"
            ;;

        '"50n"')
            icon="󰖑"
            ;;

        *) ;;
        esac

        # if [ $temp > 20 ]; then
        #     tempcolor=$red
        # fi

        #We are getting the weather for 9AM, 3PM and 9PM for each day
        # if [ $DayHour == '08' ] || [ $DayHour == '11' ] || [ $DayHour == '14' ] || [ $DayHour == '17' ] || [ $DayHour == '20' ]; then
         if [ $DayHour == '09' ] || [ $DayHour == '12' ] || [ $DayHour == '15' ] || [ $DayHour == '18' ] || [ $DayHour == '21' ]; then
            #This ${temps[$i]%%'.'*} is f*ckin magic. Converts a string for example "10.13" to "10"
            printf "^c$iconcolor^^b$black^$icon ^c$tempcolor^^b$black^${temps[$i]%%'.'*}°"
        fi
        # if [ $i == $(($lenght - 1)) ] || [ $DayHour == '20' ]; then
         if [ $i == $(($lenght - 1)) ] || [ $DayHour == '21' ]; then
            printf "$DayOfWeek^c$blue^^b$black^|"
            dayCount=$(($dayCount + 1))
        fi
        if [ $dayCount == $days ]; then
            break
        fi
    done
}

while true; do

    [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && forecast=$(get_weather) && btc=$(btc_price)
    interval=$((interval + 1))

    #sleep 2 && xsetroot -name "$updates $(cpu) $(mem) $(wlan) $(clock)"
    sleep 5 && xsetroot -name "$btc $forecast $(cpu) $(mem) $(hdd) $(clock)"

done