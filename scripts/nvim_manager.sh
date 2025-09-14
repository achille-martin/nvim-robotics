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

NEOVIM_TAG="latest"
FORCE_NEOVIM_OVERWRITE="n"


# REPO_NAME="bashrc-am-config"
# REPO_PATH="$HOME/.config/$REPO_NAME"
# STANDARD_BASHRC_NAME=".bashrc"
# STANDARD_BASHRC_PATH="$HOME/$STANDARD_BASHRC_NAME"
# CUSTOM_BASHRC_FILE_NAME=".bashrc_am"
# CUSTOM_BASHRC_PATH="$HOME/$CUSTOM_BASHRC_FILE_NAME"
# CUSTOM_BASH_ALIASES_FILE_NAME=".bash_aliases_am"
# CUSTOM_BASH_ALIASES_PATH="$HOME/$CUSTOM_BASH_ALIASES_FILE_NAME"
# CUSTOM_GIT_GRAPH_MODEL_FILE_NAME="git_graph_model_am.toml"
# GIT_GRAPH_MODELS_FOLDER_PATH="$HOME/.config/git-graph/models"

# ---- HANDY FUNCTIONS ----

print_usage() {
    multiline_usage_txt="
    Usage: bash $(basename "$0") CMD
    
    Purpose: Manage the installation and removal of neovim
             on various OS platforms (supported platforms: Linux)
	
    CMD:
        install            Install neovim for the current OS platform
                           Extra arguments: <nvim_tag> <force_overwrite>
                           * Neovim tag (x.x.x/[latest])
                           * Force overwrite of existing neovim (y/[n])
        
        uninstall          Remove neovim from current OS platform

        --help, -h         Show this help
    "
    
    printf "%s" "$multiline_usage_txt"
}

source_changes() {
    printf "\nTIP: Refresh the state of the config with the following command\n"
    printf "source $STANDARD_BASHRC_PATH\n"
}

check_os_type() {
    # Check OS type to determine support
    if [[ -z "$OSTYPE" ]];
    then
        if [[ ! $OSTYPE =~ "linux" ]];
        then
            printf "ERROR: the current OS platform is not supported.\n"
            print_usage
        fi
    else
        printf "ERROR: the current OS platform cannot be determined.\n"
        printf "Please verify the supported platforms.\n"
        print_usage
    fi
}

perform_install() {
    # Check and update extra arguments
    if [[ -z "$1" ]];
    then
        NEOVIM_TAG="$1"
        if [[ -z "$2" ]];
        then
            FORCE_NEOVIM_OVERWRITE="$2"
        fi
    fi

    # Update user about action
    printf "Starting installation of neovim with extra arguments:\n"
    printf "* neovim tag ($NEOVIM_TAG)\n"
    printf "* force neovim overwrite ($FORCE_NEOVIM_OVERWRITE)\n"

    # Download apt packages
    sudo apt-get install wget \
                         git \
                         tar \
                         ack-grep

    # Install git-graph from Github (latest versions target amd64 only)
    TMP_PATH="/tmp" &&
    wget https://github.com/mlange-42/git-graph/releases/download/0.5.0/git-graph-0.5.0-linux.tar.gz -P "$TMP_PATH" &&
    sudo tar -xf "$TMP_PATH/git-graph-0.5.0-linux.tar.gz" -C "$TMP_PATH" &&
    sudo cp $TMP_PATH/git-graph/git-graph /usr/bin/ 
    sudo rm -rf "$TMP_PATH/git-graph-0.5.0-linux.tar.gz" &&
    sudo rm -rf "$TMP_PATH/git-graph"

    # Install fzf fuzzy finder or update it if it was already installed
    FZF_FOLDER="$HOME/.fzf"
    if [[ ! -d "$FZF_FOLDER" ]]
    then
        git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_FOLDER" &&
        $FZF_FOLDER/install --key-bindings --completion --no-update-rc
    else
        cd "$FZF_FOLDER" && git pull && ./install --key-bindings --completion --no-update-rc
    fi

    # Create symlinks to custom config files
    ln -sf "$REPO_PATH/$CUSTOM_BASHRC_FILE_NAME" "$CUSTOM_BASHRC_PATH"
    ln -sf "$REPO_PATH/$CUSTOM_BASH_ALIASES_FILE_NAME" "$CUSTOM_BASH_ALIASES_PATH"
    mkdir -p "$GIT_GRAPH_MODELS_FOLDER_PATH"
    ln -sf "$REPO_PATH/$CUSTOM_GIT_GRAPH_MODEL_FILE_NAME" "$GIT_GRAPH_MODELS_FOLDER_PATH/$CUSTOM_GIT_GRAPH_MODEL_FILE_NAME"
}

perform_uninstall() {
    # Leave apt packages and other utilities
    # Note: could remove all of them but might be at risk
    # of removing important dependencies

    # Remove symlinks
    rm "$CUSTOM_BASHRC_PATH"
    rm "$CUSTOM_BASH_ALIASES_PATH"
    rm "$GIT_GRAPH_MODELS_FOLDER_PATH/$CUSTOM_GIT_GRAPH_MODEL_FILE_NAME"

    # Disable config
    perform_disable

    # Remove git folder
    cd "$REPO_PATH" &&
    cd ".." &&
    rm -rf "$REPO_PATH"
    
    # Deleted folder message
    printf "\nTIP: make sure that you are not currently in the repo that has been deleted\n"
}

# ---- MAIN ----

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

    install)
        perform_install "$2" "$3"
        ;;

    uninstall)
        perform_uninstall
        ;;

    *)
        printf "ERROR: first argument not valid\n"
        print_usage
        exit 1
        ;;
esac
