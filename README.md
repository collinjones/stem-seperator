# 🎵 AI Vocal & Instrumental Separator for macOS

A simple one-click `.command` script for macOS that uses Docker to separate vocals and instrumentals from any song using a YouTube URL — no need for premium services like Moises or LALALA.

---

## ✨ What It Does

This script:

1. Pulls the `audio-separator` Docker image.
2. Downloads audio from a YouTube link you provide.
3. Runs the Docker container with the downloaded file as input.
4. Outputs two files (Vocals and instrumental)

All in just a few steps on your Mac.

---

## ⚙️ Requirements

- macOS
- [Docker for Mac](https://www.docker.com/)

---

## How to use?


#### STEP 1. Lift Quarantine
Apple's Gatekeeper will stop this app from running because it isn't signed. Here is how to get around that. 
1. After downloading, open the folder, RIGHT CLICK on separate.command, and click Get Info
2. Right click on the path in the 'Where' attribute and click Copy as Pathname
3. Open 'Terminal' type `cd ` and then paste the Pathname. (e.g. `cd path/to/stem-seperator-main`)

Now, copy and paste the following command into your Terminal and run it. This will remove Gatekeeper's quarantine on my unsigned app. 
```bash
xattr -d com.apple.quarantine yt-dlp
xattr -d com.apple.quarantine separate.command
```

#### STEP 2. Using the app
1. Double-click on `separate.command` and it will prompt you for a choice between Local File and YouTube URL
2. Enter the URL or choose a file
3. Wait! The prompt may look frozen - it's just getting everything ready 


## 💡 Why?

Services like Moises and LALALA have daily limits or require subscriptions. This tool:
- Is free, offline, and utilizes existing open-source software
- Works great for mashups, remixes, karaoke, and production
- Similar programs like StemRoller are not working for some reason
  
Perfect if you don’t have access to stem separation in tools like Logic Pro.

---

## 🚧 Disclaimer

This tool is intended for personal and educational use only. Please respect copyright laws and the rights of original creators.
