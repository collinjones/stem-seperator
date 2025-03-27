#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
YTDLP="$SCRIPT_DIR/yt-dlp"

chmod +x "$(dirname "$0")/yt-dlp"

if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running. Attempting to launch Docker Desktop..."
  osascript -e 'tell application "Docker" to launch' >/dev/null 2>&1

  # Wait for Docker to start
  while ! docker info >/dev/null 2>&1; do
    echo "Waiting for Docker to start..."
    sleep 2
  done

  echo "Docker is now running."
fi

# Ask for URL
URL=$(osascript -e 'Tell application "System Events" to display dialog "Enter YouTube URL:" default answer ""' -e 'text returned of result' 2>/dev/null)

if [ -z "$URL" ]; then
  osascript -e 'display dialog "No URL entered. Exiting." buttons {"OK"}'
  exit 1
fi

OUTPUT_FILE="downloaded_audio.mp3"

osascript -e 'display dialog "Downloading audio..." buttons {"OK"} giving up after 1'
"$YTDLP" -x --audio-format mp3 -o "$OUTPUT_FILE" "$URL"

if [ $? -ne 0 ]; then
  osascript -e 'display dialog "Download failed." buttons {"OK"}'
  exit 1
fi

osascript -e 'display dialog "Pulling Docker image..." buttons {"OK"} giving up after 1'
docker pull beveradb/audio-separator

osascript -e 'display dialog "Running Docker..." buttons {"OK"} giving up after 1'
docker run -it -v "$(pwd)":/workdir beveradb/audio-separator "$OUTPUT_FILE"

rm "$OUTPUT_FILE"
osascript -e 'display dialog "Done! Output saved in this folder." buttons {"OK"}'
