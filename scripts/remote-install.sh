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

read -s -p "Root password: " ROOT_PASSWORD
echo

if [ -z $ROOT_PASSWORD ]; then
    echo "Empty passwords aren't allowed" >&2
    exit 1
fi

HASH=$(mkpasswd -m yescrypt "$ROOT_PASSWORD")
ESCAPED_HASH=$(printf '%s' "$HASH" | sed 's/[&/\]/\\&/g')

echo "{ users.users.root.initialHashedPassword = \"$ESCAPED_HASH\"; }" > password.nix
git add .

nix run github:nix-community/nixos-anywhere -- --flake .#$type-$conf --target-host $conf

rm password.nix
git rm --cached password.nix
