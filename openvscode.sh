#!/bin/bash

set -e

VERSION="1.64.2"
BASEURL="https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v$VERSION/openvscode-server-v$VERSION-linux"

echo "Detecting architecture..."

ARCH=`dpkg --print-architecture
case $ARCH in
  "amd64") ARCH="x64" ;;
  *) echo "Unsupported architecture. Exiting..." && exit 1 ;;
esac`

URL="$BASEURL-$ARCH.tar.gz"
VSCFOLDER="$HOME/.local/openvscode"
BINFOLDER="$HOME/.local/bin"
VSCARCHIVE="$VSCFOLDER/openvscode.tar.gz"
VSCTEMP="$VSCFOLDER/temp"

[ ! -d "$VSCFOLDER" ] && mkdir -p "$VSCFOLDER"
[ ! -d "$BINFOLDER" ] && mkdir -p "$BINFOLDER"
[ ! -d "$VSCTEMP" ] && mkdir -p "$VSCTEMP"

echo "Downloading OpenVSCode server version $VERSION..."

curl -fsSLo "$VSCARCHIVE" "$URL"

echo "Extracting OpenVSCode server version $VERSION..."

tar -zxf "$VSCARCHIVE" -C "$VSCTEMP"
rm "$VSCARCHIVE"

echo "Cleaning up..."

mv "$VSCTEMP/openvscode-server-v$VERSION-linux-$ARCH/*" "$VSCFOLDER"
rm -r "$VSCTEMP"

echo "Adding to bin..."

[ -f "$BINFOLDER/openvscode-server" ] && rm "$BINFOLDER/openvscode-server"
ln -s "$VSCFOLDER/bin/openvscode-server" "$BINFOLDER/openvscode-server"

echo "Creating uninstaller at $VSCFOLDER/uninstall.sh..."

curl -fsSLo "$VSCFOLDER/uninstall.sh" "https://raw.githubusercontent.com/RedstoneWizard08/Scripts/main/openvscode-uninstall.sh"

echo "Done!"

exit 0
