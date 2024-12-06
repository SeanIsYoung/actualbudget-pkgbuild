#!/bin/bash

# filepath: /home/dillan/Developer/actual-appimage/update_pkgbuild.sh

# Variables
PKGBUILD_PATH="/home/dillan/Developer/actual-appimage/PKGBUILD"
SRCINFO_PATH="/home/dillan/Developer/actual-appimage/.SRCINFO"
REPO="actualbudget/actual"
APPIMAGE_NAME="actual-linux.AppImage"

# Get the latest release tag from GitHub
LATEST_RELEASE=$(curl -s https://api.github.com/repos/$REPO/releases/latest | grep tag_name | cut -d '"' -f 4)

# Download the latest AppImage
curl -L -o $APPIMAGE_NAME https://github.com/$REPO/releases/download/$LATEST_RELEASE/$APPIMAGE_NAME

# Calculate the sha256sum
SHA256SUM=$(sha256sum $APPIMAGE_NAME | awk '{ print $1 }')

# Update the PKGBUILD file
sed -i "s/pkgver=.*/pkgver=$LATEST_RELEASE/" $PKGBUILD_PATH
sed -i "s/sha256sums_x86_64=('.*')/sha256sums_x86_64=('$SHA256SUM')/" $PKGBUILD_PATH
sed -i "s/pkgver = .*/pkgver = $LATEST_RELEASE/" $SRCINFO_PATH
sed -i "s/sha256sums_x86_64 = ('.*')/sha256sums_x86_64 = $SHA256SUM/" $SRCINFO_PATH

rm $APPIMAGE_NAME

echo "PKGBUILD updated with the latest release: $LATEST_RELEASE"
