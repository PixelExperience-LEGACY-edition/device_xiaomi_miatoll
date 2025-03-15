#!/bin/bash

# Clang
CLANG_PATH="prebuilts/clang/host/linux-x86/clang-latest" # Define clang path
CLANG_URL="https://github.com/userariii/clang-19_r-530567/releases/download/clang-r530567/clang-r530567.tar.gz" # Define clang URL
CLANG_TARBALL="$CLANG_PATH/clang-r*.tar.gz" # Define tarball path
CHECK_FILE="$CLANG_PATH/bin/clang" # Check if Clang is already extracted (adjust this file path if needed)
mkdir -p "$CLANG_PATH" # Ensure the directory exists
# Check if Clang is already extracted
if [ -f "$CHECK_FILE" ]; then
    echo "Clang is already installed. Skipping download."
else
    echo "Clang not found, downloading..."
    wget -O "$CLANG_TARBALL" "$CLANG_URL" # Download the tarball
    tar -xvf "$CLANG_TARBALL" -C "$CLANG_PATH" # Extract the tarball
    rm -f "$CLANG_TARBALL" # Remove the tarball
    echo "Clang has been downloaded and extracted successfully."
fi

# hardware/sony/timekeep
git clone -b lineage-20 https://github.com/LineageOS/android_hardware_sony_timekeep.git hardware/sony/timekeep --depth=1

# hardware/xiaomi
git clone -b lineage-20 https://github.com/LineageOS/android_hardware_xiaomi.git hardware/xiaomi --depth=1

# Vendor tree
git clone -b android-T https://github.com/Xiaomi-SD720G-Devices/aosp_vendor_xiaomi_miatoll.git vendor/xiaomi/miatoll --depth=1

# Kernel tree
git clone -b android-T https://github.com/Xiaomi-SD720G-Devices/aosp_kernel_xiaomi_sm6250.git kernel/xiaomi/sm6250 --depth=1