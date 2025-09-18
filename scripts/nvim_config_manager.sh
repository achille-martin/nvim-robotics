#!/bin/bash

# Released under MIT License

# Copyright (c) 2025 Achille MARTIN

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# ---- HANDY VARIABLES ----

GIT_REPO_NAME="nvim-robotics"

DEFAULT_CONFIG_FOLDER="$HOME/.config"
CONFIG_FOLDER="$DEFAULT_CONFIG_FOLDER"

DEFAULT_CONFIG_NAME="$GIT_REPO_NAME"
CONFIG_NAME="$DEFAULT_CONFIG_NAME"

DEFAULT_LOADER_SCRIPT_NAME="nvim_loader.sh"

DEFAULT_ALIAS="$DEFAULT_CONFIG_NAME"
ALIAS="$DEFAULT_ALIAS"

DEFAULT_BASH_ALIASES_FILE="$HOME/.bash_aliases"

# ---- HANDY FUNCTIONS ----

print_usage() {
    multiline_usage_txt="
    Usage: bash $(basename "$0") CMD

    Purpose: Manage the neovim configuration operations

    CMD:
        quick-setup [CONFIG-NAME]     Setup the nvim-robotics configuration
                                      as it is provided in the repo
                                      Optional argument: CONFIG-NAME
                                      (default = nvim-robotics)

        --help, -h                    Show this help
    "

    printf "%s" "$multiline_usage_txt"
}

perform_quick_setup() {
    # Warn the user that the process is starting
    printf "\nStarting quick setup of nvim-robotics configuration...\n" &&

    # Confirm the installation of nvim
    printf "\nChecking the presence of neovim...\n"
    if [[ ! $(which nvim) ]];
    then
        printf "ERROR: no neovim version has been detected.\n"
        printf "Make sure to install neovim before setting up the configuration.\n"
        printf "Please refer to the installer utility.\n"
        exit 1
    fi

    # Update variables depending on arguments
    printf "\nReading optional arguments...\n"
    if [[ -n "$1" ]]
    then
        CONFIG_NAME="$1";
        ALIAS="$CONFIG_NAME"
    fi

    # Install necessary dependencies
    printf "\nInstalling dependencies...\n"
    sudo apt-get install git

    # Store the configuration in a specific folder for nvim to find it
    # depending on the availability of SSH
    printf "\nDownloading configuration at specific location...\n"
    ssh_cmd="$(ssh -T git@github.com &>/dev/null)"
    ssh_cmd_status="$?"
    if [[ "$ssh_cmd_status" -eq 1 ]];
    then
        git clone git@gist.github.com:achille-martin/${GIT_REPO_NAME}.git "$CONFIG_FOLDER/$CONFIG_NAME"
        git_clone_cmd_status="$?"
    else
        git clone https://gist.github.com/achille-martin/${GIT_REPO_NAME}.git "$CONFIG_FOLDER/$CONFIG_NAME"
        git_clone_cmd_status="$?";
    fi

    # Proceed with the installation or warn the user about git errors
    if [[ "$git_clone_cmd_status" -eq 0 ]];
    then
        # Create a link to the nvim loader script (force overwrite if existing)
        printf "\nLinking the nvim loader script for easy access...\n"
        ln -sf "$CONFIG_FOLDER/$CONFIG_NAME/scripts/$DEFAULT_LOADER_SCRIPT_NAME" "$CONFIG_FOLDER/$DEFAULT_LOADER_SCRIPT_NAME"

        # Create the alias for the nvim robotics config (making sure it does not exist already)
        printf "\nCreating the alias for the configuration...\n"
        if [[ ! ${BASH_ALIASES[$ALIAS]} ]];
        then
            printf "alias $ALIAS=\"$CONFIG_FOLDER/$DEFAULT_LOADER_SCRIPT_NAME --custom-config '$ALIAS'\"" >> "$DEFAULT_BASH_ALIASES_FILE"
        else
            printf "WARNING: alias \`$DEFAULT_ALIAS\` is already in use, so not replaced.\n"
        fi

    else
        printf "ERROR: Cannot download repo from git. Please review the log messages.\n"
        exit 1
    fi
}

# ---- MAIN ----

# TODO:
# * Handle quick setup
# * Handle custom setup (will be done via a fork and loading side config files)
# * Handle config management? (should not be needed if fork used and loader duplicated)
# * Handle setting neovim as default editor
# * Handle config cleanup / refresh

# Ensure that there is at least one required argument entered
if [[ "$#" -lt 1 ]]
then
    printf "ERROR: one argument required\n"
	print_usage
	exit 1
fi

# Perform action depending on command entered
case "$1" in
    --help|-h)
        print_usage
	    exit 1
        ;;

    quick-setup)
        perform_quick_setup "$2"
        ;;

    *)
        printf "ERROR: first argument not valid\n"
        print_usage
        exit 1
        ;;
esac
