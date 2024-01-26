#!/bin/bash

# Version 2.2

# Configuration variables
LOG_FILE="/tmp/hypr/hyprcommandr.log"
NOTIFICATION_TIMEOUT=3000
HYPRCTL_PATH="/usr/bin/hyprctl"
JQ_PATH="/usr/bin/jq"

function usage() {
	notify-send "Usage: $0 <action> Options: restart, shutdown, logout, closeall" -t "$NOTIFICATION_TIMEOUT"
	exit 1
}

function check_command() {
	if ! command -v "$1" &>/dev/null; then
		notify-send "Error: $1 is not installed. Please install it before running this script." -t "$NOTIFICATION_TIMEOUT"
		exit 1
	fi
}

function close_all_windows() {
	local hypr_cmds
	hypr_cmds=$("$HYPRCTL_PATH" -j clients | "$JQ_PATH" -j '.[] | "dispatch closewindow address:\(.address); "')

	# Run the batch commands and log the output
	"$HYPRCTL_PATH" --batch "$hypr_cmds" >>"$LOG_FILE" 2>&1

	# Check if the batch command was successful
	if [ $? -ne 0 ]; then
		notify-send "Error: Failed to execute hyprctl batch command. Check $LOG_FILE for details." -t "$NOTIFICATION_TIMEOUT"
		exit 1
	fi
}

function execute_action() {
	case "$1" in
	restart)
		notify-send "Restarting the system..." -t "$NOTIFICATION_TIMEOUT"
		close_all_windows
		systemctl reboot >>"$LOG_FILE" 2>&1
		;;
	shutdown)
		notify-send "Shutting down the system..." -t "$NOTIFICATION_TIMEOUT"
		close_all_windows
		systemctl poweroff >>"$LOG_FILE" 2>&1
		;;
	logout)
		notify-send "Logging out..." -t "$NOTIFICATION_TIMEOUT"
		close_all_windows
		loginctl kill-session self >>"$LOG_FILE" 2>&1
		;;
	closeall)
		notify-send "Closing Windows..." -t "$NOTIFICATION_TIMEOUT"
		close_all_windows
		;;
	*)
		notify-send "Invalid action: $1. Options: restart, shutdown, logout, closeall" -t "$NOTIFICATION_TIMEOUT"
		exit 1
		;;
	esac
}

# Check if an argument is provided
if [ $# -eq 0 ]; then
	usage
fi

# Check dependencies
check_command "$HYPRCTL_PATH"
check_command "$JQ_PATH"

execute_action "$1"

# Display success message as a notification
notify-send "Script executed successfully. Check $LOG_FILE for details." -t "$NOTIFICATION_TIMEOUT"
exit 0
