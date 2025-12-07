#!/bin/bash
set -e

# Configuration
FIVEM_PATH="/opt/fivem/server"
DATA_PATH="/opt/fivem/server-data"
# Link to the "Recommended" build for Linux
ARTIFACT_URL="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/22934-1c490ee35560b652c97a4bfd5a5852cb9f033284/fx.tar.xz"

echo "--- 🟢 Starting FiveM Container Setup ---"

# 1. Install/Update Server Artifacts if missing
if [ ! -d "$FIVEM_PATH" ]; then
    echo "--- ⬇️ Downloading FiveM Artifacts... ---"
    mkdir -p $FIVEM_PATH
    cd $FIVEM_PATH
    curl -O $ARTIFACT_URL
    echo "--- 📦 Extracting... ---"
    tar xf fx.tar.xz
    rm fx.tar.xz
    echo "--- ✅ Artifacts installed. ---"
else
    echo "--- ℹ️ FiveM Artifacts already exist. Skipping download. ---"
fi


# ----------------------------------------------------------------
# NEW: Setup SFTP (SSH) User
# ----------------------------------------------------------------
if [ -n "$SFTP_PASSWORD" ]; then
    echo "--- 🔑 Setting SFTP (root) password... ---"
    echo "root:$SFTP_PASSWORD" | chpasswd
else
    echo "--- ⚠️ No SFTP_PASSWORD set. SFTP access may fail! ---"
fi

echo "--- 📡 Starting SSH Service... ---"
service ssh start
# ----------------------------------------------------------------

# We use a loop here so if the server crashes, 
# it restarts automatically after 5 seconds, keeping the container open.
while true; do
    bash $FIVEM_PATH/run.sh
    echo "--- ❌ Server crashed or stopped. Restarting in 5 seconds... ---"
    sleep 5
done