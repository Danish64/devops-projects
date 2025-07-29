#!/bin/bash

# Print header
echo "=== SERVER HEALTH CHECK ==="
echo "Timestamp: $(date)"
echo "Hostname: $(hostname)"
echo "----------------------------------------"

# OS & General Info
echo ">>> OS VERSION, UPTIME, LOAD AVERAGE, LOGGED IN USERS"
cat /etc/os-release | grep PRETTY_NAME     # Show OS version
uptime                                      # Show uptime and load average
w -h | awk '{print $1, $2, $3, $4}'         # Show logged in users
echo "----------------------------------------"

# CPU Usage
echo ">>> TOTAL CPU USAGE"
top -bn1 | grep "Cpu(s)" | awk '{print "User: "$2"%, System: "$4"%, Idle: "$8"%"}'
# Shows CPU breakdown: user/system/idle
echo "----------------------------------------"

# Memory Usage
echo ">>> MEMORY USAGE (USED / TOTAL / PERCENTAGE)"
free -h                                      # Human-readable memory stats
MEM_USED=$(free | awk '/Mem:/ {print $3}')  # Used memory in KB
MEM_TOTAL=$(free | awk '/Mem:/ {print $2}') # Total memory in KB
MEM_PERCENT=$((100 * MEM_USED / MEM_TOTAL)) # Usage percentage
echo "Memory Usage: $MEM_USED / $MEM_TOTAL = $MEM_PERCENT%"
echo "----------------------------------------"

# Disk Usage
echo ">>> DISK USAGE"
df -h --total | grep total  # Shows total disk usage (all mounted filesystems)
echo "----------------------------------------"

# Top 5 Processes by CPU
echo ">>> TOP 5 PROCESSES BY CPU USAGE"
ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head -n 6
# Lists top 5 CPU-consuming processes
echo "----------------------------------------"

# Top 5 Processes by Memory
echo ">>> TOP 5 PROCESSES BY MEMORY USAGE"
ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%mem | head -n 6
# Lists top 5 memory-consuming processes
echo "----------------------------------------"

# Failed login attempts
echo ">>> FAILED LOGIN ATTEMPTS (last 24 hours)"
lastb | awk -v d="$(date --date="1 day ago" '+%Y-%m-%d')" '$0 ~ d,0'
# Shows failed login attempts in the past 24 hours
echo "----------------------------------------"

# Network interfaces
echo ">>> NETWORK INTERFACES AND ERRORS"
ip -s link  # Shows packet stats and errors per interface
echo "----------------------------------------"

# Systemd failed services
echo ">>> SYSTEMD FAILED SERVICES"
systemctl --failed  # Lists systemd units that failed to start
echo "----------------------------------------"

# Network connections summary
echo ">>> OPEN NETWORK CONNECTIONS SUMMARY"
ss -s  # Shows TCP/UDP connection summary
echo "----------------------------------------"

# End
echo ">>> END OF REPORT"
