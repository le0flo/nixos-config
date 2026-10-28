#!/usr/bin/env bash

type=$1
conf=$2

if [ -z $type ]; then
    echo "No configuration type specified" >&2
    exit 1
fi

if [ -z $conf ]; then
    echo "No configuration specified" >&2
    exit 1
fi

nixos-rebuild switch --flake .#$type-$conf --target-host $conf --ask-sudo-password
