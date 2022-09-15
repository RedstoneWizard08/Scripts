#!/bin/bash

echo ">> Updating system..."

sudo apt update -yqq
sudo apt upgrade -y
sudo apt autoremove -y

echo ">> Adding i386 support..."

sudo dpkg --add-architecture i386

sudo apt update -yqq
sudo apt upgrade -y
sudo apt autoremove -y

echo ">> Installing Wine..."

sudo wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
sudo apt update -yqq

sudo apt install -y --install-recommends winehq-stable wine gedit

echo ">> Installing DirectX..."

curl -fsSLo directx_9.0c_redist.exe https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe

echo "Please choose the folder \"~/.wine_tmp\" in the installer."

wine directx_9.0c_redist.exe

wine ~/.wine_tmp/dxsetup.exe

wine ~/.wine/drive_c/windows/system32/dxdiag.exe

echo ">> Updating missing DLLs..."

curl -fsSLo mscoree.dll https://github.com/RedstoneWizard08/Scripts/raw/main/mscoree.dll
curl -fsSLo streamci.dll https://github.com/RedstoneWizard08/Scripts/raw/main/streamci.dll

cp mscoree.dll ~/.wine/drive_c/windows/system32/
cp streamci.dll ~/.wine/drive_c/windows/system32/

echo "Please configure the libraries using this website: https://www.dedoimedo.com/games/wine-directx.html"

winecfg
