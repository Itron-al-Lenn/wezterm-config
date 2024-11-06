#!/bin/bash

file_guard='/tmp/gui-fixed'

if ! test -f $file_guard; then
    sudo umount --quiet /tmp/.X11-unix
    sudo rm -rf /tmp/.X11-unix
    sudo ln -s /mnt/wslg/.X11-unix /tmp/.X11-unix
    sudo ln -s /mnt/wslg/runtime-dir/wayland-0* /run/user/1000/
    sudo touch $file_guard
fi
