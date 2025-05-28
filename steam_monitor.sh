#!/bin/bash

# START Mandatory Var
STEAM_API_KEY=""
STEAM_USER_ID=""
# END Mandatory Var

# START Optional Var
DISCORD_WEBHOOK_URL=""
EMAIL=""
# END Optional Var

# You can modify the name of the file.
LOG_FILE="steam_game_log.txt"

# Function to send email notification
send_email_notification() {
    if [ -n "$EMAIL" ]; then
        echo "Subject: Steam Game Notification - $1" | sendmail -v $EMAIL
    else
        echo "$(date '+%A %d %B %Y, %H:%M:%S'): $1" >> $LOG_FILE
    fi
}

# Function to send Discord notification
send_discord_notification() {
    if [ -n "$DISCORD_WEBHOOK_URL" ]; then
        curl -H "Content-Type: application/json" -d "{\"content\": \"$1\"}" $DISCORD_WEBHOOK_URL
    else
        echo "$(date '+%A %d %B %Y, %H:%M:%S'): $1" >> $LOG_FILE
    fi
}

# Function to check if Steam user ID and API key are defined
check_user_defined() {
    if [ -z "$STEAM_API_KEY" ]; then
        echo "Error: Steam API key is not defined. Please set a Steam API key."
        exit 1
    fi

    if [ -z "$STEAM_USER_ID" ]; then
        echo "Error: Steam user ID is not defined. Please set a Steam username."
        exit 1
    fi
}

# Check if Steam user ID and API key are defined
check_user_defined

# Track play sessions
previous_state="offline"
while true; do
    response=$(curl -s "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=$STEAM_API_KEY&steamids=$STEAM_USER_ID")
    # echo "API Response: $response" # Debugging output
    # echo $response >> $LOG_FILE # Debugging output in the log file
    is_playing=$(echo $response | jq -r '.response.players[0].gameid')
    player_name=$(echo $response | jq -r '.response.players[0].personaname')
    game_name=$(echo $response | jq -r '.response.players[0].gameextrainfo')

    if [ "$is_playing" != "null" ]; then
        if [ "$previous_state" == "offline" ]; then
            start_time=$(date +%s)
            start_time_formatted=$(date '+%A %d %B %Y, %H:%M:%S')
            previous_state="online"
            send_email_notification "$player_name started playing to $game_name at $start_time_formatted!"
            send_discord_notification "$player_name started playing to $game_name at $start_time_formatted!"
        fi
    else
        if [ "$previous_state" == "online" ]; then
            end_time=$(date +%s)
            end_time_formatted=$(date '+%A %d %B %Y, %H:%M:%S')
            play_time=$((end_time - start_time))

            if [ $play_time -ge 3600 ]; then
                play_time_formatted="$((play_time / 3600)) heure(s)"
            else
                play_time_formatted="$((play_time / 60)) minute(s)"
            fi

            previous_state="offline"
            send_email_notification "$player_name stopped playing to $game_name at $end_time_formatted! Total game time : $play_time_formatted."
            send_discord_notification "$player_name stopped playing to $game_name at $end_time_formatted! Total game time : $play_time_formatted."
        fi
    fi

    sleep 60 # Check every 60 seconds
done
