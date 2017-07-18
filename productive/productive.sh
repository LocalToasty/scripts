#!/bin/bash
#
# productive.sh
#
# A script that blocks distracting websites.
#
# Websites to be blocked when productive mode is turned on have to be
# inserted into /etc/hosts in the following fashion:
#
# `#127.0.0.1 <website> blocked` (note the leading `#`)

case $1 in
    on)
        sed -i 's/^#\(.*[\t ]blocked\)$/\1/' /etc/hosts
        ;;
    off)
        sed -i 's/^[^#].*blocked$/#&/' /etc/hosts
        ;;
    *)
	      echo "usage: $0 (on|off) [time]"
        exit 0
	      ;;
esac

if [ -n "$2" ]; then
    # revert the given setting after $2 time
    sleep "$2"
    case $1 in
        on)
            sed -i 's/^[^#].*blocked$/#&/' /etc/hosts
            ;;
        off)
            sed -i 's/^#\(.*blocked\)$/\1/' /etc/hosts
            ;;
    esac
fi
