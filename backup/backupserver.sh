#!/bin/bash

config_dir=/etc/backup

# error states
err_config_not_readable=-1
err_server_unreachable=-2

# check if the right number of arguments was supplied
if [ $# -ne 1 ]; then
    echo "usage: $0 <name>"
    echo
    echo "The back up is created according to the config file at" \
             "$config_dir/<name>.conf"
    exit 0
fi

name="$1"
config_path="$config_dir/$name.conf"

# load config
echo "Loading config '$config_path'"
. "$config_path"
if [ $? -ne 0 ]; then
    echo "Error: failed to read '$config_path'"
    exit $err_config_not_readable
fi

# get back up from server
ping -c 1 "${server[host]}" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    bup init
    echo "Saving the following paths:"
    printf "  '%s'\n" "${backup_dirs[@]}"
    bup on "${server[user]}"@"${server[host]}" index -u "${backup_dirs[@]}"
    bup on "${server[user]}"@"${server[host]}" save \
        -n "$name" "${backup_dirs[@]}"
    exit 0
else
    echo "Error: unable to reach '${server[host]}'"
    exit $err_server_unreachable
fi
