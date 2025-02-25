#!/bin/bash

# get current cpu usage
# top -l 1 | grep -E "^CPU" | grep -Eo '[^[:space:]]+%' | head -1

echo -n " "
top -l 1 | grep -E "^CPU" | grep -Eo '[^[:space:]]+%' | head -1
