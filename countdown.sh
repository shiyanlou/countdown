#!/bin/bash

function SetTime()
{
    local c_hour=`date +%H`
    local c_minute=`date +%M`
    local c_time=`date +%H:%M:%S`
    s_time=`dialog --stdout --title "Set Time" --time-format %H\:%M\:%S --timebox\
        "Current time is\n$c_time\nPlease set the deadtime\n" 0 0 $c_hour $c_minute 00`
}

function _exit()
{
    if [ -n "$music" ];then
        mocp -x
    fi
    clear
    exit 0
}

function show_erro()
{
    echo "Usage: $0 [option] [value]"
    exit 1
}

while [ -n "$1" ];do
    case "$1" in
    -c) option="-c" ;;
    -m) shift
        music=$2 ;;
    -i) shift
        info=$2 ;;
     *) show_erro ;;
    esac
    shift
done
SetTime
s_seconds=`date -d $s_time +%s`
c_seconds=`date +%s`
e_seconds=$((s_seconds - c_seconds))
./disclock $option $e_seconds $info
if [ $? -eq 0 ];then
    if [ -n "$music" ];then
        mocp -S $music
        mocp -p
    fi
    zenity --info --width=100 --text=$info
    if [ $? -eq 0 ];then
        _exit
    fi
fi

trap " _exit " SIGINT
sleep 1000
_exit
