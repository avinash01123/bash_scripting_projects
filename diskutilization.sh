#!/bin/bash

echo "Checking disk usage in the Linux system"

# Get the disk usage percentage and free space of the root partition
disk_usage=$(df -h | grep "/dev/mapper/data-root" | awk '{print $5}')
free_space=$(df -h | grep "/dev/mapper/data-root" | awk '{print $4}')
size=$(df -h | grep "/dev/mapper/data-root" | awk '{print $2}')

# Extract the numeric value for disk usage percentage (without '%')
disk_size=$(echo $disk_usage | cut -d '%' -f 1)

# Display disk usage and free space
echo "Disk Usage: $disk_usage"
echo "Free Space: $free_space"
echo "Total Size: $size"

# Check if disk usage is greater than 80%
if [ "$disk_size" -gt 80 ]; then
  echo "Disk usage is more than 80%, consider expanding the disk or deleting files soon."
else
  echo "Enough disk space is available."
fi

