#!/usr/bin/env bash

conf=$1

if [ -z $conf ]; then
    echo "No configuration specified" >&2
    exit 1
fi

nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode destroy,format,mount --flake .#$conf

nixos-install --flake .#$conf
