#!/usr/bin/env bash

if [ $# == 0 ]; then
    read -s -p "Root password: " ROOT_PASSWORD
    echo

    if [ -z $ROOT_PASSWORD ]; then
        echo "Empty passwords aren't allowed" >&2
        exit 1
    fi

    HASH=$(mkpasswd -m yescrypt "$ROOT_PASSWORD")
    ESCAPED_HASH=$(printf '%s' "$HASH" | sed 's/[&/\]/\\&/g')

    sed -i.bak "s|\"root\".initialHashedPassword = null;|\"root\".initialHashedPassword = \"$ESCAPED_HASH\";|" hosts/template.nix

    echo "Initial password set"
elif [ $1 == "reset" ]; then
    git restore hosts/template.nix
    rm -f hosts/*.bak

    echo "Initial password reset"
fi
