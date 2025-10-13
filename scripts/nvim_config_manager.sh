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
DEFAULT_SHORT_ALIAS="neo"
SHORT_ALIAS="$DEFAULT_SHORT_ALIAS"

DEFAULT_BASH_ALIASES_FILE="$HOME/.bash_aliases"
DEFAULT_BASHRC_FILE="$HOME/.bashrc"

INSTALLER_UTILITY_NAME="nvim_installer.sh"

DEFAULT_LOCAL_FOLDER="$HOME/.local"

VIM_PLUG_LATEST_VERSION="0.14.0"

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

        cleanup [CONFIG-NAME]         Clean up the nvim-robotics configuration
                                      Optional argument: CONFIG-NAME
                                      If opt arg provided, only cleans up
                                      the configuration related to CONFIG-NAME

        --help, -h                    Show this help
    "

    printf "%s" "$multiline_usage_txt"
}

source_changes() {
    printf "\nACTION: Refresh the state of the environment with the following command:\n"
    printf "source $DEFAULT_BASHRC_FILE\n"
}

install_plugins() {
    printf "\nACTION: Finish installation of third-party Neovim plugins with the following command:\n"
    printf "$ALIAS -c PlugUpgrade -c PlugInstall -c PlugUpdate -c qall"
}

perform_quick_setup() {
    # Confirm the installation of nvim
    printf "\nChecking the presence of neovim...\n"
    if [[ ! $(which nvim) ]];
    then
        printf "ERROR: no neovim version has been detected.\n"
        printf "Make sure to install neovim before setting up the configuration.\n"
        printf "Please refer to the installer utility: \`$INSTALLER_UTILITY_NAME\`\n"
        exit 1
    fi
    printf "...done\n"

    # Update variables depending on arguments
    printf "\nReading optional arguments...\n"
    if [[ -n "$1" ]]
    then
        CONFIG_NAME="$1";
        ALIAS="$CONFIG_NAME"
    fi
    printf "...done\n"

    # Install necessary dependencies
    # Note: the `ripgrep` dependency is not really necessary
    # but it speeds up the Neovim startup time (load of `vim._defaults`)
    # according to the following bug (mainly on WSL):
    # https://github.com/neovim/neovim/issues/31506
	# If the package is not available via apt,
	# refer to the alternative installation methods if desired:
	# https://github.com/BurntSushi/ripgrep#installation
    printf "\nInstalling necessary dependencies...\n"
    sudo apt-get install git
    sudo apt-get install curl
    sudo apt-get install ripgrep
    printf "...done\n"

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
    printf "...done\n"

    # Proceed with the installation or warn the user about git errors
    if [[ "$git_clone_cmd_status" -eq 0 ]];
    then
        # Create a link to the nvim loader script (force overwrite if existing)
        printf "\nLinking the nvim loader script for easy access...\n"
        ln -sf "$CONFIG_FOLDER/$CONFIG_NAME/scripts/$DEFAULT_LOADER_SCRIPT_NAME" "$CONFIG_FOLDER/$DEFAULT_LOADER_SCRIPT_NAME"
        printf "...done\n"

        # Create the alias for the nvim robotics config (making sure it does not exist already)
        # and create a practical alias for the launch of the custom nvim robotics config
        printf "\nCreating the alias for the configuration...\n"
        if [[ ! ${BASH_ALIASES[$ALIAS]} ]];
        then
            printf "alias $ALIAS=\"$CONFIG_FOLDER/$DEFAULT_LOADER_SCRIPT_NAME --custom-config '$ALIAS'\"\n" >> "$DEFAULT_BASH_ALIASES_FILE"
            printf "alias $SHORT_ALIAS=\"$ALIAS\"" >> "$DEFAULT_BASH_ALIASES_FILE"
        else
            printf "WARNING: alias \`$ALIAS\` is already in use, so not replaced.\n"
        fi
        printf "...done\n"

        # Add the plugin manager to take care of
        # downloading, installing and setting up third-party Neovim plugins
        printf "\nSetting up the plugin manager...\n"
        sh -c 'curl -fLo ${CONFIG_FOLDER}/${CONFIG_NAME}/autoload/plug.vim \
                    --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/${VIM_PLUG_LATEST_VERSION}/plug.vim'
        printf "...done\n"

    else
        printf "ERROR: Cannot download repo from git. Please review the log messages.\n"
        exit 1
    fi

    source_changes
    install_plugins
}

perform_cleanup() {
    # Update variables depending on arguments
    printf "\nReading optional arguments...\n"
    if [[ -n "$1" ]]
    then
        CONFIG_NAME="$1";
        ALIAS="$CONFIG_NAME"
    fi
    printf "...done\n"

    # Moving to a neutral folder
    printf "\nMoving to a neutral folder...\n"
    cd "$HOME"
    printf "...done\n"

    # Remove the configuration from the config folder
    printf "\nRemoving configuration located in config folder \`$CONFIG_FOLDER\`...\n"
    rm "$CONFIG_FOLDER/$DEFAULT_LOADER_SCRIPT_NAME"
    rm -rf "$CONFIG_FOLDER/$CONFIG_NAME"
    printf "...done\n"

    # Remove the user data from the local folder
    printf "\nRemoving user data from the local folder \`$DEFAULT_LOCAL_FOLDER\`...\n"
    rm -rf "$DEFAULT_LOCAL_FOLDER/share/$CONFIG_NAME"
    printf "...done\n"

    # Remove configuration aliases
    printf "\nRemoving alias configuration in \`$DEFAULT_BASH_ALIASES_FILE\`...\n"
    grep -v "alias $ALIAS=\"$CONFIG_FOLDER/$DEFAULT_LOADER_SCRIPT_NAME --custom-config '$ALIAS'\"" "$DEFAULT_BASH_ALIASES_FILE" > "/tmp/.bash_aliases"
    mv "/tmp/.bash_aliases" "$DEFAULT_BASH_ALIASES_FILE"
    grep -v "alias $SHORT_ALIAS=\"$ALIAS\"" "$DEFAULT_BASH_ALIASES_FILE" > "/tmp/.bash_aliases"
    mv "/tmp/.bash_aliases" "$DEFAULT_BASH_ALIASES_FILE"
    printf "...done\n"

	source_changes
}

# ---- MAIN ----

# TODO:
# * Handle custom setup (will be done via a fork and loading side config files)
# * Handle config management (should not be needed if fork used and loader duplicated)
# * Handle setting neovim as default editor

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

    cleanup)
        perform_cleanup "$2"
        ;;

    *)
        printf "ERROR: first argument not valid\n"
        print_usage
        exit 1
        ;;
esac
