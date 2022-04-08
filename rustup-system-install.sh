#!/bin/bash

export RUSTUP_HOME=/usr/local/rust
export CARGO_HOME=/usr/local/rust

apt-get update
apt-get install -y curl bash
curl -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path

source /usr/local/rust/env
rustup default stable

for FILE in "$RUSTUP_HOME/bin/"*; do
    if [[ -f "/usr/local/bin/$(basename "$FILE")" ]]; then
        rm "/usr/local/bin/$(basename "$FILE")"
    fi
    if [[ -f "$FILE" ]]; then
        ln -sf "$FILE" "/usr/local/bin/$(basename "$FILE")"
    fi
done

printf "\e[32m\e[1mPlease run this command: \e[0m\e[1mrustup default stable\e[0m\n"
