# 🎵 AI Vocal & Instrumental Separator for macOS

A simple one-click `.command` script for macOS that uses Docker to separate vocals and instrumentals from any song using a YouTube URL — no need for premium services like Moises or LALALA.

---

## ✨ What It Does

This script:

1. Pulls the `audio-separator` Docker image.
2. Downloads audio from a YouTube link you provide.
3. Runs the Docker container with the downloaded file as input.
4. Outputs two files:
   - `vocals.wav`
   - `instrumental.wav`

All in just a few steps on your Mac.

---

## ⚙️ Requirements

- macOS
- [Docker for Mac](https://www.docker.com/products/docker-desktop)
- [yt-dlp](https://github.com/yt-dlp/yt-dlp)

---

### 🧰 Installing Homebrew (if you don’t have it)

Homebrew is a package manager for macOS that lets you install tools like `yt-dlp` easily.

To install Homebrew, open Terminal and run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
