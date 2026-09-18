#!/usr/bin/env bash

host=$1

if [ -z $host ]; then
    echo "No host configuration specified" >&2
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

echo "{ users.root.initialHashedPassword = \"$ESCAPED_HASH\"; }" > hosts/password.nix
git add .

nix run github:nix-community/nixos-anywhere -- --flake .#host-$host --target-host $host

rm hosts/password.nix
git rm --cached hosts/password.nix
