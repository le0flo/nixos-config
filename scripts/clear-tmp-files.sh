#!/usr/bin/env bash

rm -f *.img *.log *.pid *.sock result
find . -maxdepth 1 -type f -name '*.lock' ! -name 'flake.lock' -delete
