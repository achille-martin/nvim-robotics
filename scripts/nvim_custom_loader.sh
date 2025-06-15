#! /bin/bash

# ---- PRE-REQUISITES ----

# * Functional for Linux Ubuntu OS
# * Make sure that your bashrc contains the base path of your nvim executable: 
#   `echo 'export PATH="$PATH:/opt/nvim/bin"' >> $HOME/.bashrc`
# * Move this current script to `$HOME/.config`
# * Make the current script executable: 
#   `chmod +x "$HOME/.config/nvim_custom_loader.sh"`
# * Add a new editor alternative: 
#   `sudo update-alternatives --install /usr/bin/editor editor "$HOME/.config/nvim_custom_loader.sh" 100`
# * Set new editor as default through auto mode (high priority): 
#   `sudo update-alternatives --auto editor`

# ---- USER CONFIG ----

# Pick custom config name
CUSTOM_CONFIG_NAME="nvim-achille"

# ---- AUTOMATIC LOAD ----

GENERAL_CONFIG_FOLDER="$HOME/.config"
DEFAULT_NVIM_BIN_FOLDER="/opt/nvim/bin"
DEFAULT_NVIM_EXECUTABLE="$DEFAULT_NVIM_BIN_FOLDER/nvim"
IS_NVIM_FOUND=false

# Check whether custom config folder exists
if [[ ! -e "$GENERAL_CONFIG_FOLDER/$CUSTOM_CONFIG_NAME" ]]
then
    printf "WARNING: custom nvim config $CUSTOM_CONFIG_NAME does not exist in $GENERAL_CONFIG_FOLDER, "
    printf "trying with default config.\n"
fi

# Check whether nvim executable can be found
if [[ ! -z "$(which nvim)" ]]
then
    IS_NVIM_FOUND=true
else
    printf "WARNING: nvim executable cannot be found, "
    printf "trying with absolute path $DEFAULT_NVIM_EXECUTABLE.\n"
fi

# Load nvim with config
if [[ $IS_NVIM_FOUND ]]
then
    NVIM_APPNAME="$CUSTOM_CONFIG_NAME" nvim "$@"
else
    NVIM_APPNAME="$CUSTOM_CONFIG_NAME" "$DEFAULT_NVIM_EXECUTABLE" "$@"
fi
