#!/bin/bash

# System Monitoring Script

# Required variables
cpu_usage="$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d . -f1)"
th=1

# Email configuration
recipient="macamex587@sfxeur.com"
subject="High CPU Usage Alert"
alert_log="/tmp/cpu_alert_log.txt"

# Monitor CPU usage and trigger alert if threshold exceeded
if [[ "$cpu_usage" -gt "$th" ]]; then
    echo "High CPU Usage Detected: $cpu_usage%"

    # Alert notification logic
    echo "High CPU Usage Detected: $cpu_usage% on $(date)" >> "$alert_log"
    
    # Compose the email message
    echo -e "Subject: $subject\n\nHigh CPU Usage Alert:\nCPU Usage is currently at $cpu_usage%, exceeding the threshold of $th%.\n\nLogged at: $(date)" | sendmail "$recipient"
fi
