#!/bin/bash

# get current cpu usage
echo -n " "
top -l 1 | grep -E "^CPU" | grep -Eo '[^[:space:]]+%' | head -1
