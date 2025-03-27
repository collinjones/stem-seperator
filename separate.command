#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YTDLP="$SCRIPT_DIR/yt-dlp"
TEMP_AUDIO="downloaded_audio.mp3"

# Ensure yt-dlp is executable
chmod +x "$YTDLP"

# Function to display a dialog and return user input
get_user_input() {
  osascript -e 'Tell application "System Events" to display dialog "'"$1"'" default answer ""' \
            -e 'text returned of result' 2>/dev/null
}

# Check if Docker is running, try to launch if not
if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running. Attempting to start Docker Desktop..."
  osascript -e 'tell application "Docker" to launch' >/dev/null 2>&1

  for i in {1..30}; do
    if docker info >/dev/null 2>&1; then
      echo "Docker started successfully."
      break
    fi
    echo "Waiting for Docker to start... ($i/30)"
    sleep 2
  done

  if ! docker info >/dev/null 2>&1; then
    osascript -e 'display dialog "Docker failed to start after 60 seconds. Exiting." buttons {"OK"}'
    exit 1
  fi
fi

# Ask the user for input source
CHOICE=$(osascript -e 'choose from list {"YouTube URL", "Local File"} with prompt "Select input source:"' 2>/dev/null)

# Handle cancel or close
if [ "$CHOICE" = "false" ] || [ -z "$CHOICE" ]; then
  osascript -e 'display dialog "No input selected. Exiting." buttons {"OK"}'
  exit 1
fi

INPUT_FILE=""

if [ "$CHOICE" = "YouTube URL" ]; then
  URL=$(get_user_input "Enter YouTube URL:")
  if [[ -z "$URL" ]]; then
    osascript -e 'display dialog "No URL entered. Exiting." buttons {"OK"}'
    exit 1
  fi

  osascript -e 'display dialog "Downloading audio..." buttons {"OK"} giving up after 1'
  if ! "$YTDLP" -x --audio-format mp3 -o "$SCRIPT_DIR/$TEMP_AUDIO" "$URL"; then
    osascript -e 'display dialog "Download failed." buttons {"OK"}'
    exit 1
  fi

  INPUT_FILE="$TEMP_AUDIO"

elif [ "$CHOICE" = "Local File" ]; then
  FILE_PATH=$(osascript -e 'POSIX path of (choose file with prompt "Select a local audio file")' 2>/dev/null)

  if [[ ! -f "$FILE_PATH" ]]; then
    osascript -e 'display dialog "Invalid file selected. Exiting." buttons {"OK"}'
    exit 1
  fi

  INPUT_FILE="$(basename "$FILE_PATH")"
  cp "$FILE_PATH" "$SCRIPT_DIR/$INPUT_FILE"
fi

# Pull Docker image
osascript -e 'display dialog "Pulling Docker image..." buttons {"OK"} giving up after 1'
docker pull beveradb/audio-separator

# Run the container
osascript -e 'display dialog "Running Docker..." buttons {"OK"} giving up after 1'
docker run --rm -v "$SCRIPT_DIR:/workdir" -w /workdir beveradb/audio-separator "$INPUT_FILE"

# Cleanup downloaded file if applicable
if [[ "$INPUT_FILE" == "$TEMP_AUDIO" ]]; then
  rm -f "$SCRIPT_DIR/$TEMP_AUDIO"
fi

osascript -e 'display dialog "Done! Output saved in this folder." buttons {"OK"}'
