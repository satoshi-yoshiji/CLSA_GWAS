#!/bin/bash

# Absolute path to the base directory
BASE_DIR="/scratch/richards/satoshi.yoshiji/40.CLSA_TG_to_HDL/02.regenie/01.step1"

# List of target directories
directories=(
    "EUR_both"
    "EUR_female"
    "EUR_male"
)

#directories=(
#    "AFR_both"
#    "AFR_female"
#    "AFR_male"
#    "EUR_both"
#    "EUR_female"
#    "EUR_male"
#    "EAS_both"
#    "EAS_female"
#    "EAS_male"
#    "SAS_both"
#    "SAS_female"
#    "SAS_male"
#)

# Path to the original script
original_script="$BASE_DIR/01.regenie_step1.sh"

# Check if the original script exists
if [ ! -f "$original_script" ]; then
    echo "Error: $original_script not found."
    exit 1
fi

# Iterate over each directory
for dir in "${directories[@]}"; do
    TARGET_DIR="$BASE_DIR/$dir"
    echo "Processing directory: $TARGET_DIR"

    # Create the target directory if it does not exist
    mkdir -p "$TARGET_DIR"

    # Copy the original script to the target directory
    cp "$original_script" "$TARGET_DIR/"

    # Create log directory inside target directory
    mkdir -p "$TARGET_DIR/log"

    # Extract ancestry and sex label from directory name
    ancestry="${dir%%_*}"   # Extracts text before the first underscore (e.g., "AFR")
    sex_label="${dir#*_}"   # Extracts text after the first underscore (e.g., "both")

    # Path to the copied script
    copied_script="$TARGET_DIR/01.regenie_step1.sh"

    # Replace placeholders XXX and YYY with actual values
    sed -i "s/XXX/${ancestry}/g; s/YYY/${sex_label}/g" "$copied_script"

    # Make sure the script is executable
    chmod +x "$copied_script"

    # Submit the job using sbatch from within the target directory
    (
        cd "$TARGET_DIR" || { echo "Failed to enter directory $TARGET_DIR"; exit 1; }
        sbatch "./01.regenie_step1.sh"
    )

    echo "Submitted job for $dir"
    echo "----------------------------------------"
done
