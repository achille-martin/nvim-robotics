#!/bin/bash

# MIT License
#
# Copyright (c) 2025 Achille MARTIN
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# ---- PRE-REQUISITES ----

# * Script functional only for a selected set of OS (for instance Linux Ubuntu)
# * Make sure that your bashrc contains the base path of your nvim executable:
#   `echo 'export PATH="$PATH:/opt/nvim/bin"' >> $HOME/.bashrc`
# * Make sure that the current script is executable:
#   `chmod +x "$HOME/.config/nvim-robotics/scripts/nvim_loader.sh"`
# * Symlink this current script to `$HOME/.config` (for easier/universal access):
#   `ln -sf "$HOME/.config/nvim-robotics/scripts/nvim_loader.sh" "$HOME/.config/nvim_loader.sh"`
# * Add a new editor alternative:
#   `sudo update-alternatives --install /usr/bin/editor editor "$HOME/.config/nvim_loader.sh" 100`
# * Set new editor as default through auto mode (high priority):
#   `sudo update-alternatives --auto editor`
#   Note: to remove the editor from the alternatives:
#   `sudo update-alternatives --remove editor "$HOME/.config/nvim_loader.sh"`

# ---- EXTERNAL SOURCES ----

# WARNING: the external sources need to be located in the same folder
# as this script
# (or in the case of a symlink, in the same folder as the target)
bash_source_symlink=$(readlink -f $BASH_SOURCE)
if [[ $bash_source_symlink == */* ]]
then
    cd -- "${bash_source_symlink%/*}/"
fi
source helper_functions.sh

# SAFETY: make sure that the script operates in the folder
# it was executed from, to be able to function as expected with neovim commands
cd - &> /dev/null

# ---- HANDY VARIABLES ----

# Set the custom config name to default name
# of a folder existing in the default config folder,
# as it is useful for update-alternatives and default nvim behaviour
# Note: the custom config name can also be updated via bash arguments
CUSTOM_CONFIG_NAME="$DEFAULT_CUSTOM_CONFIG_NAME"

# Collect args for nvim command
NVIM_ARGS_ARRAY=()

# Set handy flags
IS_NVIM_ARG_DETECTED=false

# ---- HANDY FUNCTIONS ----

print_usage() {
    multiline_usage_txt="
    Usage: $(basename "$0") [OPTIONS] [NVIM_ARGS]

    Purpose: Extend capabililties of nvim command to load a custom config

    Options:
        --custom-config NAME    Optional. Set custom config for nvim.
                                Needs to be set before the nvim arguments.

    Other arguments:
	    NVIM_ARGS               Optional. Arguments for the nvim command.
    "

    printf "%s" "$multiline_usage_txt"
}

check_arguments() {
    while [[ $# -gt 0 ]]
    do
        case $1 in
            --custom-config)
                if [[ "$IS_NVIM_ARG_DETECTED" == "false" ]]
                then
                    if [[ -n $2 && $2 != -* ]]
                    then
                        CUSTOM_CONFIG_NAME="$2"
                        shift 2
                    else
                        printf "ERROR: --custom-config requires one non-empty argument.\n"
                        print_usage
                        exit 1
                    fi
                else
                    printf "ERROR: options for $(basename "$0") must be placed before nvim arguments.\n"
                    print_usage
                    exit 1
                fi
                ;;
            *)
                IS_NVIM_ARG_DETECTED=true
                NVIM_ARGS_ARRAY+=( $1 )
                shift 1
                ;;
        esac
    done
}

check_config() {
    if [[ ! -e "$DEFAULT_CONFIG_FOLDER/$CUSTOM_CONFIG_NAME" ]]
    then
        printf "WARNING: custom nvim config \`$CUSTOM_CONFIG_NAME\` does not exist in \`$DEFAULT_CONFIG_FOLDER\`, "
        printf "trying with default nvim config.\n"
    fi
}

check_nvim() {
    refresh_nvim_presence
    if [[ "$IS_NVIM_AVAILABLE" == "false" ]]
    then
        printf "WARNING: nvim executable cannot be found, "
        printf "trying with absolute path \`$DEFAULT_NVIM_EXECUTABLE\`.\n"
    fi
}

load_nvim() {
    if [[ "$IS_NVIM_AVAILABLE" == "true" ]]
    then
        NVIM_APPNAME="$CUSTOM_CONFIG_NAME" nvim "$@"
    else
        NVIM_APPNAME="$CUSTOM_CONFIG_NAME" "$DEFAULT_NVIM_EXECUTABLE" "$@"
    fi
}

# ---- MAIN ----

main_fn() {
    check_arguments "$@"
    check_config
    check_nvim
    load_nvim "${NVIM_ARGS_ARRAY[@]}"
}

main_fn "$@"
