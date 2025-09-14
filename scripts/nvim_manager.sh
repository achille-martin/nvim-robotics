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
INSTALL_UNSUPPORTED_BUILD="n"
OS_DETECTED="unknown"
OS_DISTRIBUTION_DETECTED="unknown"
OS_ARCHITECTURE_DETECTED="unknown"

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
        install            Install latest neovim version
                           for the current OS platform
                           (supported platforms: Linux Ubuntu x86_64)
                           Extra optional arg: <unsupported_build> (y/[n])
        
        uninstall          Remove neovim from current OS platform

        --help, -h         Show this help
    "
    
    printf "%s" "$multiline_usage_txt"
}

source_changes() {
    printf "\nTIP: Refresh the state of the terminal with the following command\n"
    printf "source $STANDARD_BASHRC_PATH\n"
}

check_os_type() {
    # Check OS specifications to determine support
    if [[ -z "$OSTYPE" ]];
    then
        if [[ "$OSTYPE" =~ "[linux|Linux|LINUX]" ]];
        then
            OS_DETECTED="linux"
            distribution_detected="$(lsb_release -i)"
            if [[ "$distribution_detected" =~ "[ubuntu|Ubuntu|UBUNTU]" ]];
            then
                OS_DISTRIBUTION_DETECTED="ubuntu"
                architecture_detected="$(uname -r)"
                if [[ "$architecture_detected" =~ "x86_64" ]];
                then
                    OS_ARCHITECTURE_DETECTED="x86_64"
                else
                    printf "ERROR: the architecture \`$architecture_detected\` is not supported.\n"
                    print_usage
                fi
            else
                printf "ERROR: the distribution \`$distribution_detected\` is not supported.\n"
                print_usage
            fi
        else
            printf "ERROR: the current OS \`$OSTYPE\` is not supported.\n"
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
        INSTALL_UNSUPPORTED_BUILD="$1"
    fi

    # Update user about action
    printf "Starting installation of neovim with extra optional argument:\n"
    printf "* Install unsupported build ($INSTALL_UNSUPPORTED_BUILD)\n"

    # Handle the different OS platforms supported
    case "$OS_DETECTED" in

        linux)
            # Ensure there is no neovim version clash
            if [[ ! $(which "nvim") ]];
            then
                printf "ERROR: a neovim version has been detected.\n"
                printf "Make sure to remove existing versions of neovim before installation.\n"
                print_usage
            fi

            # Download and install the latest neovim version
            downloads_folder="$HOME/Downloads"
            if [[ ! -d "$downloads_folder"  ]];
            then
                mkdir -p "$downloads_folder"
            fi
            cd $downloads_folder

            sudo apt-get install curl

            case "$OS_ARCHITECTURE" in

                x84_64)
                    curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
                    # Install neovim in /opt
                    sudo tar -C "/opt" -xzf "nvim-linux-x86_64.tar.gz"
                    sudo mv "/opt/nvim-linux-x86_64" "/opt/nvim"
                    cd -
                    # Add neovim path to bashrc (if not there already)
                    bashrc_path="$HOME/.bashrc"
                    bashrc_content=$(sed '' "$bashrc_path")
                    source_neovim_cmd_txt='export PATH="$PATH:/opt/nvim/bin"'
                    if [[ ! "$bashrc_content" =~ "$source_neovim_cmd_txt" ]];
                    then
                        printf "# Load neovim"
                        printf 'export PATH="$PATH:/opt/nvim/bin"' >> "$bashrc_path"
                    fi
                    ;;

                *)
                    printf "ERROR: the current OS architecture \`$OS_ARCHITECTURE\` is not supported.\n"
                    cd -
                    print_usage
                    ;;

            esac

            ;;

        *)
            printf "ERROR: the current OS \`$OS_DETECTED\` is not supported.\n"
            print_usage
            ;;

    esac
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

# Ensure that the OS platform is supported
check_os_type

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
