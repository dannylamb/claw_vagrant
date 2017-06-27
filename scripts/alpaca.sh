#!/bin/sh
# Alpaca
echo "Building Alpaca"

HOME_DIR="/root"

if [ -f "$HOME_DIR/islandora/configs/variables" ]; then
  . "$HOME_DIR"/islandora/configs/variables
fi

cd "$HOME_DIR"
git clone https://github.com/Islandora-CLAW/Alpaca.git
cd Alpaca
./gradlew install
