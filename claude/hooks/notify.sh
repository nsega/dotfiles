#!/bin/bash
# Claude Code Notification hook: forward notifications (permission requests,
# idle prompts, task completion) to the macOS Notification Center.
# Receives hook JSON on stdin; silently no-ops on non-macOS or parse failure.

command -v osascript >/dev/null 2>&1 || exit 0

message=$(/usr/bin/python3 -c 'import json,sys; print(json.load(sys.stdin).get("message",""))' 2>/dev/null)
[ -n "$message" ] || exit 0

# Escape double quotes for AppleScript
message=${message//\"/\\\"}
osascript -e "display notification \"${message}\" with title \"Claude Code\"" >/dev/null 2>&1

exit 0
