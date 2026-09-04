#!/bin/bash

# Configure environment variables 
ORACLE_BASE=/u01/app/oracle
ORACLE_HOME=$ORACLE_BASE/product/11.2.0.4/dbhome_1
ORACLE_SID=srvbdatm
EXECUTE_PATH=/datos/atm_jobs/alert_log


# Configure the necessary variables
ALERT_LOG_PATH="$ORACLE_BASE/alert_srvbdatm.log"  # Path to the Oracle alert log
BOT_TOKEN="1234567890:AABBCCDDEEFFGGHHiiJJKKllMMNNOOppQQRRSSTTUUVVwwxxYYzz"                # Token for the Telegram bot
CHAT_ID="0987654321"                    # Chat ID to send the message to
TELEGRAM_API="https://api.telegram.org/bot$BOT_TOKEN/sendMessage"
ERROR_LOG="$EXECUTE_PATH/log.err"     # Log file for script errors

# Function to send messages to Telegram
send_telegram_message() { 
    local message=$1
    response=$(curl -s -X POST $TELEGRAM_API -d chat_id=$CHAT_ID -d text="$message")
    if [ $? -ne 0 ]; then
        echo "$(date) - Error sending message to Telegram: $message" >> $ERROR_LOG
        echo "$(date) - cURL error response: $response" >> $ERROR_LOG
    fi
}

# Function to monitor the alert log file and detect errors
monitor_alert_log() {
    if [ ! -f "$ALERT_LOG_PATH" ]; then
        echo "$(date) - Log file does not exist: $ALERT_LOG_PATH" >> $ERROR_LOG
        send_telegram_message "Error: Log file does not exist: $ALERT_LOG_PATH"
        exit 1
    fi

    tail -F "$ALERT_LOG_PATH" | while read -r line
    do
        # Search for lines containing "ORA-" (indicative of Oracle errors)
        if echo "$line" | grep -q "ORA-"; then
            send_telegram_message "Oracle error detected: $line"
        fi
    done
}

# Handle script interruption (e.g., Ctrl+C)
trap 'echo "$(date) - Script interrupted." >> $ERROR_LOG; exit 0' SIGINT SIGTERM

# Start monitoring the log
monitor_alert_log



