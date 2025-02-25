#!/bin/bash

# Get total memory in GB
total_gb=$(sysctl -n hw.memsize | awk '{print $1 / 1024 / 1024 / 1024}')

# Get used memory from top (wired + active + compressed)
physmem=$(top -l 1 -s 0 | grep PhysMem)
used_mem=$(echo "$physmem" | awk '{print $2}' | tr -d 'G') # Extract used memory in GB

# Round used memory
used_gb=$(printf "%.0f\n" "$used_mem")

# Print result
echo "  ${used_gb}/${total_gb%.*}GB"
