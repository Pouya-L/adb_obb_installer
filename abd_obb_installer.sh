#!/bin/bash

usage() {
    echo "Usage: $0 <package_name> [--reinstall]"
    echo "Example: $0 com.test.app --reinstall"
    exit 1
}

# Require at least 1 argument
if [ "$#" -lt 1 ]; then
    usage
fi

project_name=$1
reinstall=0

# Check for optional --reinstall flag
if [ "$2" = "--reinstall" ]; then
    reinstall=1
fi

# Get the latest .apk and .obb files in current directory
APK=$(ls -t *.apk 2>/dev/null | head -n1)
OBB=$(ls -t *.obb 2>/dev/null | head -n1)

# Validate the existence of files
if [ -z "$APK" ]; then
    echo "❌ No .apk file found in current directory."
    exit 1
fi

if [ -z "$OBB" ]; then
    echo "❌ No .obb file found in current directory."
    exit 1
fi

echo "📦 APK to install: $APK"
echo "🗂️ OBB to push: $OBB"
echo "🤖 Package name: $project_name"
echo "🔁 Reinstall mode: $reinstall"

echo "📂 Creating OBB directory and pushing OBB..."
adb shell mkdir -p /sdcard/Android/obb/$project_name
adb push -p "$OBB" /sdcard/Android/obb/$project_name/

echo "📲 Installing APK..."
if [ "$reinstall" = "1" ]; then
    adb install -r "$APK"
else
    adb install "$APK"
fi
