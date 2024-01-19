#!/usr/bin/env bash

function run {
    if ! pgrep $1 ; then
        $@&
    fi
}

if xrandr | grep -q 'DP-1-3 connected' ; then
    xrandr --output DP-1-3 --left-of eDP-1 --auto
fi
