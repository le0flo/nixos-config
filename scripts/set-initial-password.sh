#!/usr/bin/env bash

read -s -p "Root password: " ROOT_PASSWORD

HASH=$(mkpasswd -m yescrypt "$ROOT_PASSWORD")

# TODO: da continuare
