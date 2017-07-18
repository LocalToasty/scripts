#!/bin/bash

case $1 in
    on)
        sed -i 's/^#\(.*blocked\)$/\1/' /etc/hosts
        ;;
    off)
        sed -i 's/^[^#].*blocked$/#&/' /etc/hosts
        ;;
    *)
	echo "usage: $0 (on|off)"
	;;
esac
