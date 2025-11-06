#!/bin/bash

# === Step 0: Variables ===
ANDROID_SDK_ROOT=$HOME/Android/Sdk
CMDLINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip"
NDK_VERSION="21.4.7075529"
PROJECT_DIR="$HOME/PROJECTS/IDSnap"

# === Step 1: Remove broken system sdkmanager if exists ===
sudo apt remove google-android-cmdline-tools-11.0-installer -y

# === Step 2: Create SDK directories ===
mkdir -p $ANDROID_SDK_ROOT/cmdline-tools
mkdir -p $ANDROID_SDK_ROOT/ndk

# === Step 3: Download & install cmdline-tools locally ===
cd $HOME
wget $CMDLINE_TOOLS_URL -O cmdline-tools.zip
unzip -qo cmdline-tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools
mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest
rm cmdline-tools.zip

# === Step 4: Add cmdline-tools to PATH temporarily ===
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin

# Optional: Make permanent
if ! grep -q 'ANDROID_SDK_ROOT' ~/.bashrc; then
  echo "export ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT" >> ~/.bashrc
  echo "export PATH=\$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin" >> ~/.bashrc
fi

# === Step 5: Accept licenses ===
yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT --licenses

# === Step 6: Install stable NDK 21.4 ===
sdkmanager --sdk_root=$ANDROID_SDK_ROOT "ndk;$NDK_VERSION"

# === Step 7: Verify NDK installation ===
echo "Installed NDK versions:"
ls $ANDROID_SDK_ROOT/ndk/

# === Step 8: Update project local.properties ===
echo "ndk.dir=$ANDROID_SDK_ROOT/ndk/$NDK_VERSION" > $PROJECT_DIR/android/local.properties

# === Step 9: Clean React Native Android project ===
cd $PROJECT_DIR/android
./gradlew clean
cd $PROJECT_DIR

# === Step 10: Build & run on emulator or device ===
npx react-native run-android
