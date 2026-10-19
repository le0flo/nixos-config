#!/usr/bin/env bash

host=$1

if [ -z $host ]; then
    echo "No host configuration specified" >&2
    exit 1
fi

nixos-rebuild switch --flake .#host-$host --target-host $host --ask-sudo-password
