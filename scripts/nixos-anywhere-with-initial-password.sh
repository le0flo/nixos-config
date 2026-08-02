#!/usr/bin/env bash

set -euo pipefail

read -s -p "Root password: " ROOT_PASSWORD

HASH=$(mkpasswd -m yescrypt "$ROOT_PASSWORD")

cat > "./hosts/initialPassword.nix" <<EOF
{
  users.users."root".initialHashedPassword = "$HASH";
}
EOF

nix run github:nix-community/nixos-anywhere -- $@

git restore ./hosts/initialPassword.nix
