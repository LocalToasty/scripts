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

echo "Saving the following paths:"
printf "  '%s'\n" "${backup_dirs[@]}"

rm -r ~/.bup # circumvent strange bug

# send back up to server
ping -c 1 "${server[host]}" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Saving at '${server[user]}"@"${server[host]}":"${server[bup_dir]}'"
    bup init -r "${server[user]}"@"${server[host]}":"${server[bup_dir]}"
    bup index -u "${backup_dirs[@]}"
    bup save -r "${server[user]}"@"${server[host]}":"${server[bup_dir]}" \
        -n "$name" "${backup_dirs[@]}"
    exit $?
else
    echo "Error: unable to reach '${server[host]}'"
    exit $err_server_unreachable
fi
