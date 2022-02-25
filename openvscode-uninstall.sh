#!/bin/bash

set -e

VSCFOLDER="$HOME/.local/openvscode"
BINFOLDER="$HOME/.local/bin"

echo "Uninstalling OpenVSCode server..."

[ -d "$VSCFOLDER" ] && rm -r "$VSCFOLDER"

echo "Removing executables from path..."

[ -f "$BINFOLDER/openvscode-server" ] && rm "$BINFOLDER/openvscode-server"

echo "Done!"

exit 0
