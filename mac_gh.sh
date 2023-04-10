#!/usr/bin/env zsh

# Installs the GitHub CLI tool on macs.

if [[ "$HOME/.local/bin" =~ .*"$PATH".* ]] || [[ "~/.local/bin" =~ .*"$PATH".* ]]; then
    echo "~/.local/bin is in PATH. OK"
else
    echo "~/.local/bin is not in PATH. Adding to .zshrc."
    echo "export PATH=\"$HOME/.local/bin:\$PATH\"" >> ~/.zshrc
fi

wget https://github.com/cli/cli/releases/download/v2.27.0/gh_2.27.0_macOS_amd64.tar.gz -qO gh.tgz
tar -zxf gh.tgz
rm gh.tgz

if [[ ! -d "$HOME/.local/bin" ]]; then
    mkdir -p "$HOME/.local/bin"
fi

mv gh_2.27.0_macOS_amd64/bin/gh "$HOME/.local/bin/gh"
rm -rf gh_2.27.0_macOS_amd64
