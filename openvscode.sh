#!/bin/bash

set -e

echo "OpenVSCode installer v1.0.0 by RedstoneWizard08"
echo ""

VERSION="1.64.2"
BASEURL="https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v$VERSION/openvscode-server-v$VERSION-linux"

echo "Detecting system architecture..."

ARCH=`dpkg --print-architecture`
case $ARCH in
  "amd64") ARCH="x64" ;;
  "arm64") ARCH="arm64" ;;
  "armhf") ARCH="armhf" ;;
  *) echo "Unsupported architecture. Exiting..."; exit 1 ;;
esac

echo "Found architecture: $ARCH"

URL="$BASEURL-$ARCH.tar.gz"
VSCFOLDER="$HOME/.local/openvscode"
BINFOLDER="$HOME/.local/bin"
VSCARCHIVE="$VSCFOLDER/openvscode.tar.gz"
VSCTEMP="$VSCFOLDER/temp"

function removeOldBin {
    [ -f "$BINFOLDER/openvscode-server" ] && rm "$BINFOLDER/openvscode-server"
    newInstall
}

function continueInstall {
    [ ! -d "$VSCFOLDER" ] && mkdir -p "$VSCFOLDER"
    [ ! -d "$BINFOLDER" ] && mkdir -p "$BINFOLDER"
    [ ! -d "$VSCTEMP" ] && mkdir -p "$VSCTEMP"

    echo "Downloading OpenVSCode server version $VERSION..."

    curl -fsSLo "$VSCARCHIVE" "$URL"

    echo "Extracting OpenVSCode server version $VERSION..."

    tar -zxf "$VSCARCHIVE" -C "$VSCTEMP"
    rm "$VSCARCHIVE"

    echo "Cleaning up..."

    mv $VSCTEMP/openvscode-server-v$VERSION-linux-$ARCH/* "$VSCFOLDER"
    rm -r "$VSCTEMP"

    echo "Adding to bin..."

    [ -f "$BINFOLDER/openvscode-server" ] && rm "$BINFOLDER/openvscode-server"
    ln -s "$VSCFOLDER/bin/openvscode-server" "$BINFOLDER/openvscode-server"

    sed -i 's/\$ROOT/$VSCFOLDER/g' "$VSCFOLDER/bin/openvscode-server"

    sed -i 's/\#\!\/usr\/bin\/env\ssh//g' "$VSCFOLDER/bin/openvscode-server"

    sed -i '1i \#\!\/usr\/bin\/env\ sh\n\nVSCFOLDER\=\$HOME\/.local\/openvscode' "$VSCFOLDER/bin/openvscode-server"

    sed -i 's/\#\sGenerated\sby\sthe\sOpenVSCode\sinstaller\sscript\.//g' "$HOME/.bashrc"
    sed -i 's/export\sPATH="\$PATH\:\$BINFOLDER"//g' "$HOME/.bashrc"

    [ ! -x "$(command -v openvscode-server)" ] && echo "Adding $BINFOLDER to \$PATH..."; export PATH="$PATH:$BINFOLDER"; echo "" >> $HOME/.bashrc; echo "# Generated by the OpenVSCode installer script." >> $HOME/.bashrc; echo "export PATH=\"\$PATH:\$BINFOLDER\"" >> $HOME/.bashrc
    
    echo "Creating uninstaller at $VSCFOLDER/uninstall.sh..."

    curl -fsSLo "$VSCFOLDER/uninstall.sh" "https://raw.githubusercontent.com/RedstoneWizard08/Scripts/main/openvscode-uninstall.sh"

    echo "Done!"

    exit 0
}

function otherDir {
    read -p "What directory should we use? (Enter an absolute path, no variables): " dir
    read -p "Confirming install to: $dir (y/n): " yn
    case $yn in
        [Yy]* ) echo "Continuing..."; VSCFOLDER="$dir"; continueInstall ;;
        [Nn]* ) echo "Exiting..."; exit 1 ;;
        *) echo "Exiting..."; exit 1 ;;
    esac
}

function newInstall {
    read -p "OpenVSCode Server will be installed to $VSCFOLDER. Is that okay? (y/n): " yn
    case $yn in
        [Yy]* ) echo "Continuing..."; continueInstall ;;
        [Nn]* ) otherDir ;;
        *) otherDir ;;
    esac
}

if [[ -d "$VSCFOLDER" ]]; then
    read -p "A previous install was found at $VSCFOLDER. Reinstall it? (y/n): " yn
    case $yn in
        [Yy]* ) echo "Removing old install at $VSCFOLDER..."; rm -r "$VSCFOLDER"; removeOldBin ;;
        [Nn]* ) echo "Exiting..."; exit 1 ;;
        *) echo "Exiting..."; exit 1 ;;
    esac
else
    newInstall
fi
