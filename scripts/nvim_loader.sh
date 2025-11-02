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

# * Functional only for Linux Ubuntu OS (for now)
# * Make sure that your bashrc contains the base path of your nvim executable:
#   `echo 'export PATH="$PATH:/opt/nvim/bin"' >> $HOME/.bashrc`
# * Move this current script to `$HOME/.config`
# * Make the current script executable:
#   `chmod +x "$HOME/.config/nvim_loader.sh"`
# * Add a new editor alternative:
#   `sudo update-alternatives --install /usr/bin/editor editor "$HOME/.config/nvim_loader.sh" 100`
# * Set new editor as default through auto mode (high priority):
#   `sudo update-alternatives --auto editor`
#   Note: to remove the editor from the alternatives:
#   `sudo update-alternatives --remove editor "$HOME/.config/nvim_loader.sh"`

# ---- HANDY VARIABLES ----

# Set the default custom config name
# of a folder existing in the default config folder
# for update-alternatives and default nvim behaviour
DEFAULT_CUSTOM_CONFIG_NAME="nvim-robotics"
CUSTOM_CONFIG_NAME="$DEFAULT_CUSTOM_CONFIG_NAME"

# Set the default config folder and executable folder
# for nvim
DEFAULT_CONFIG_FOLDER="$HOME/.config"
DEFAULT_NVIM_BIN_FOLDER="/opt/nvim/bin"
DEFAULT_NVIM_EXECUTABLE="$DEFAULT_NVIM_BIN_FOLDER/nvim"

# Collect args for nvim command
NVIM_ARGS_ARRAY=()

# Set handy flags
IS_NVIM_ARG_DETECTED=false
IS_NVIM_FOUND=false

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
    while [[ $# -gt 0 ]]; do
        case $1 in
            --custom-config)
                if [[ $IS_NVIM_ARG_DETECTED == "false" ]]
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
    if [[ ! -z "$(which nvim)" ]]
    then
        IS_NVIM_FOUND=true
    else
        printf "WARNING: nvim executable cannot be found, "
        printf "trying with absolute path \`$DEFAULT_NVIM_EXECUTABLE\`.\n"
    fi
}

load_nvim() {
    if [[ $IS_NVIM_FOUND ]]
    then
        NVIM_APPNAME="$CUSTOM_CONFIG_NAME" nvim "$@"
    else
        NVIM_APPNAME="$CUSTOM_CONFIG_NAME" "$DEFAULT_NVIM_EXECUTABLE" "$@"
    fi
}

# ---- MAIN ----

main() {
    check_arguments "$@"
    check_config
    check_nvim
    load_nvim "${NVIM_ARGS_ARRAY[@]}"
}

main "$@"
