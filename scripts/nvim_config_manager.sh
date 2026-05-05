#!/bin/bash -i

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

# ---- EXTERNAL SOURCES ----

# WARNING: the external sources need to be located in the same folder
# as this script
if [[ "$BASH_SOURCE" == */* ]]; then
    cd -- "${BASH_SOURCE%/*}/"
fi
source helper_functions.sh

# ---- HANDY VARIABLES ----

GIT_REPO_NAME="$DEFAULT_CUSTOM_CONFIG_NAME"
TARGET_GIT_REPO_BRANCH="$DEFAULT_TARGET_GIT_REPO_BRANCH"

CONFIG_FOLDER="$DEFAULT_CONFIG_FOLDER"

DEFAULT_CONFIG_NAME="$GIT_REPO_NAME"
CONFIG_NAME="$DEFAULT_CONFIG_NAME"

DEFAULT_ALIAS="$DEFAULT_CONFIG_NAME"
ALIAS="$DEFAULT_ALIAS"
SHORT_ALIAS="$DEFAULT_SHORT_ALIAS"

# ---- HANDY FUNCTIONS ----

print_usage() {
    multiline_usage_txt="
    Usage: bash $(basename "$0") CMD

    Purpose: Manage the neovim configuration operations

    Requires: Access to \`helper_functions.sh\`

    CMD:
        --help, -h                    Show this help

        --branch, -b BRANCH-NAME      Specify the target branch or tag
                                      to use for \`$GIT_REPO_NAME\`
                                      By default, the branch used is \`main\`

        quick-setup [CONFIG-NAME]     Setup the \`$GIT_REPO_NAME\` configuration
                                      as it is provided in the repo
                                      Optional argument: CONFIG-NAME
                                      (default = \`$DEFAULT_CONFIG_NAME\`)

        cleanup [CONFIG-NAME]         Clean up the \`$DEFAULT_CONFIG_NAME\` configuration
                                      Optional argument: CONFIG-NAME
                                      If opt arg provided, only cleans up
                                      the configuration related to CONFIG-NAME
    "

    printf "%s" "$multiline_usage_txt"
}

## Optional argument: "warning" to display warnings and actions to the user
install_plugins() {
    if [[ "$1" == "warning" ]];
    then
        printf "\n/ ! \\ ACTION MIGHT BE REQUIRED: Finish installation of third-party Neovim plugins with the following command\n"
        printf "➤ $ALIAS -c PlugUpgrade -c PlugInstall -c PlugUpdate -c qall\n"
    fi
    $ALIAS --headless -c PlugUpgrade -c PlugInstall -c PlugUpdate -c qall &> "/dev/null"
}

perform_quick_setup() {
    printf "\n--------------------\n"
    printf "Starting quick setup of nvim config ↺ \n"

    # Confirm the installation of nvim
    printf "\nChecking the presence of neovim...\n"
    refresh_nvim_presence
    if [[ "$IS_NVIM_AVAILABLE" == "false" ]];
    then
        printf "ERROR: no neovim version has been detected.\n"
        printf "Make sure to install neovim before setting up the configuration.\n"
        printf "Please refer to the installer utility: \`$DEFAULT_INSTALLER_UTILITY_NAME\`\n"
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
    #
    # Note: the `ripgrep` dependency is not really necessary
    # but it speeds up the Neovim startup time (load of `vim._defaults`)
    # according to the following bug (mainly on WSL):
    # https://github.com/neovim/neovim/issues/31506
	# If the package is not available via apt,
	# refer to the alternative installation methods if desired:
	# https://github.com/BurntSushi/ripgrep#installation
    #
    # Further note: the `nodejs` and `npm` dependencies
    # are only required for the setup of the LSP capabilities
    # of specific languages
    printf "\nInstalling necessary apt dependencies...\n"
    sudo apt-get update &&
    sudo apt-get install git -y
    sudo apt-get install curl -y
    ## Note: the following apt dependencies
    ## improve grep capabilities in neovim
    sudo apt-get install ripgrep -y
    ## Note: the following apt dependencies
    ## help with LSP server installation
    sudo apt-get install zip -y
    sudo apt-get install unzip -y
    sudo apt-get install python3-venv -y
    ## Note: the following apt dependencies
    ## are required by nvim-treesitter
    sudo apt-get install tar -y
    # Verify gcc presence on the current OS
    local is_gcc_available="0"
    if [[ "$(which gcc)" ]]; then
        is_gcc_available="1"
    fi
    # Install gcc (if not already available) for nvim-treesitter
    if [[ "$is_gcc_available" -eq 0 ]]; then
        sudo apt-get install build-essential -y
    fi
    # Verify shellcheck presence on the current OS
    local is_shellcheck_available="0"
    if [[ "$(which shellcheck)" ]]; then
        is_shellcheck_available="1"
    fi
    # Install shellcheck (if not already available) to improve LSP capabilities
    if [[ "$is_shellcheck_available" -eq 0 ]]; then
        sudo apt-get install shellcheck -y
    fi
    printf "...done\n"

    printf "\nInstalling nodejs and npm dependencies...\n"
    # Verify nodejs and npm presence on the current OS
    # so that custom config for these packages is not altered
    local is_nodejs_available="0"
    local is_npm_available="0"
    if [[ "$(which node)" ]]; then
        is_nodejs_available="1"
    fi
    if [[ "$(which npm)" ]]; then
        is_npm_available="1"
    fi
    # Install nodejs and npm via the node version manager
    # to have full control
    # on the selection of the versions installed and in use
    if [[ "$is_nodejs_available" -eq 1 && "$is_npm_available" -eq 1 ]]; then
        printf "INFO: nodejs and npm seem to be installed.\n"
        printf "Make sure that a recent version has been installed\n"
        printf "to benefit from the latest features of the neovim config.\n"
    elif [[ "$is_nodejs_available" -eq 1 && "$is_npm_available" -eq 0 ]]; then
        printf "WARNING: nodejs seems to be installed, but not npm.\n"
        printf "Make sure that npm is installed\n"
        printf "to benefit from the latest features of the neovim config.\n"
    elif [[ "$is_nodejs_available" -eq 0 && "$is_npm_available" -eq 1 ]]; then
        printf "WARNING: npm seems to be installed, but not nodejs.\n"
        printf "Make sure that nodejs is properly installed\n"
        printf "to benefit from the latest features of the neovim config.\n"
    elif [[ "$is_nodejs_available" -eq 0 && "$is_npm_available" -eq 0 ]]; then
        local curl_cmd=""
        local curl_cmd_status=""
        refresh_latest_nvm_version
        curl_cmd="$(curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_LATEST_VERSION}/install.sh" | bash)"
        curl_cmd_status="$?"
        # Report any curl error to the user
        if [[ "$curl_cmd_status" -ne 0 ]];
        then
            printf "WARNING: Cannot install nodejs and/or npm.\n"
            printf "Therefore, some functionalities might not be available\n"
            printf "in this neovim config.\n"
        else
            # Source changes to make sure `nvm` command is available
            source_changes
            # TODO: Select nodejs version to use
            # depending on the support status of the OS platform
            # * latest LTS nodejs version for fully supported OS platforms
            # * gallium/v16 for unsupported distribution major releases?
            #
            # NOTE: to uninstall nvm (along with npm and nodejs), run the following
            # nvm_dir="${NVM_DIR:-~/.nvm}"
            # nvm unload
            # rm -rf "$nvm_dir"
            # (and manually remove the nvm lines in your bashrc)
            local nvm_cmd=""
            local nvm_cmd_status=""
            nvm_cmd="$(nvm install --lts)"
            nvm_cmd_status="$?"
            # Report any nvm error to the user
            if [[ "$nvm_cmd_status" -ne 0 ]];
            then
                printf "WARNING: Cannot install nodejs and/or npm.\n"
                printf "Therefore, some functionalities might not be available\n"
                printf "in this neovim config.\n"
            fi
        fi
    fi
    printf "...done\n"

    printf "\nInstalling additional nvim-treesitter dependencies via Rust...\n"
    # Verify Rust presence on the current OS
    # so that custom config is not altered
    local is_rust_available="0"
    if [[ "$(which rustc)" ]]; then
        is_rust_available="1"
    fi
    if [[ "$is_rust_available" -eq 1 ]]; then
        printf "INFO: Rust seems to be installed.\n"
        printf "Make sure that a recent version has been installed\n"
        printf "to benefit from the latest features of the neovim config.\n"
    else
        local curl_cmd=""
        local curl_cmd_status=""
        curl_cmd="$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y)"
        curl_cmd_status="$?"
        # Report any curl error to the user
        if [[ "$curl_cmd_status" -ne 0 ]];
        then
            printf "WARNING: Cannot install Rust.\n"
            printf "Therefore, some functionalities might not be available\n"
            printf "in this neovim config.\n"
        else
            local src_cmd=""
            src_cmd="$(source "$HOME/.cargo/env")"
            source_changes

            ## NOTE: this dependency installation fixes a bug
            ## because rquickjs depends on it
            ## https://github.com/DelSkayn/rquickjs/issues/589
            local apt_cmd=""
            apt_cmd="$(sudo apt install clang -y)"
        fi
    fi
    # Install tree-sitter-cli via Rust
    local cargo_cmd=""
    local cargo_cmd_status=""
    cargo_cmd="$(cargo install --locked tree-sitter-cli)"
    cargo_cmd_status="$?"
    # Report any cargo error to the user
    if [[ "$cargo_cmd_status" -ne 0 ]]; then
        printf "WARNING: Cannot install tree-sitter-cli.\n"
        printf "Therefore, some functionalities might not be available\n"
        printf "in this neovim config.\n"
    fi
    printf "...done\n"

    printf "\nInstalling fzf dependency...\n"
    # Verify fzf presence on the current OS
    # so that custom config is not altered
    local is_fzf_available="0"
    if [[ "$(which fzf)" ]]; then
        is_fzf_available="1"
    fi
    if [[ "$is_fzf_available" -eq 1 ]]; then
        printf "INFO: fzf seems to be installed.\n"
        printf "Make sure that a recent version has been installed\n"
        printf "to benefit from the latest features of the neovim config.\n"
    else
        local FZF_FOLDER="$HOME/.fzf"
        local git_cmd=""
        local git_cmd_status=""
        if [[ ! -d "$FZF_FOLDER" ]]; then
            git_cmd="$(git clone --depth 1 "https://github.com/junegunn/fzf.git" "$FZF_FOLDER" &&
                "$FZF_FOLDER/install" --key-bindings --completion --update-rc)"
            git_cmd_status="$?"
            # Report any git error to the user
            if [[ "$git_cmd_status" -ne 0 ]]; then
                printf "WARNING: Cannot install fzf.\n"
                printf "Therefore, some functionalities might not be available\n"
                printf "in this neovim config.\n"
            fi
        else
            git_cmd="$(cd "$FZF_FOLDER" && git pull && ./install --key-bindings --completion --update-rc)"
            git_cmd_status="$?"
            # Report any git error to the user
            if [[ "$git_cmd_status" -ne 0 ]]; then
                printf "WARNING: Cannot install or update fzf.\n"
                printf "Therefore, some functionalities might not be available\n"
                printf "in this neovim config.\n"
            fi
        fi
    fi
    printf "...done\n"

    # Store the configuration in a specific folder for nvim to find it
    # depending on the availability of SSH
    printf "\nDownloading configuration at specific location...\n"
    local ssh_cmd=""
    local ssh_cmd_status=""
    local git_clone_cmd_status=""
    # Note: ensure strict host key checking with SSH
    # in case the channel is not properly set up
    ssh_cmd="$(ssh -o StrictHostKeyChecking=yes -T "git@github.com" &> "/dev/null")"
    ssh_cmd_status="$?"
    # Note: according to Github docs, the exit status
    # of the ssh user verification command is usually 1
    # if it was successful
    if [[ "$ssh_cmd_status" -eq 0 || "$ssh_cmd_status" -eq 1 ]];
    then
        git clone -b "$TARGET_GIT_REPO_BRANCH" "git@github.com:achille-martin/${GIT_REPO_NAME}.git" "$CONFIG_FOLDER/$CONFIG_NAME"
        git_clone_cmd_status="$?"
    else
        git clone -b "$TARGET_GIT_REPO_BRANCH" "https://github.com/achille-martin/${GIT_REPO_NAME}.git" "$CONFIG_FOLDER/$CONFIG_NAME"
        git_clone_cmd_status="$?";
    fi
    # Report any git error to the user
    if [[ "$git_clone_cmd_status" -ne 0 ]];
    then
        printf "ERROR: Cannot download repo from git. Please review the log messages.\n"
        exit 1
    fi
    printf "...done\n"

    # Create a link to the nvim loader script (force overwrite if existing)
    printf "\nLinking the nvim loader script for easy access...\n"
    ln -sf "$CONFIG_FOLDER/$CONFIG_NAME/scripts/$DEFAULT_LOADER_SCRIPT_NAME" "$CONFIG_FOLDER/$DEFAULT_LOADER_SCRIPT_NAME"
    printf "...done\n"

    # Create the alias for the nvim robotics config (making sure it does not exist already)
    # and create a practical alias for the launch of the custom nvim robotics config
    printf "\nCreating the alias for the configuration...\n"
    if [[ ! "${BASH_ALIASES[$ALIAS]}" ]];
    then
        printf "alias $ALIAS=\"$CONFIG_FOLDER/$DEFAULT_LOADER_SCRIPT_NAME --custom-config '$ALIAS'\"\n" >> "$DEFAULT_BASH_ALIASES_PATH"
        printf "alias $SHORT_ALIAS=\"$ALIAS\"" >> "$DEFAULT_BASH_ALIASES_PATH"
    else
        printf "WARNING: alias \`$ALIAS\` is already in use, so not replaced.\n"
    fi
    printf "...done\n"

    # Install the plugin manager (overwrite if existing) to take care of
    # downloading, installing and setting up third-party Neovim plugins
    printf "\nInstalling the plugin manager...\n"
    local curl_cmd=""
    local curl_cmd_status=""
    refresh_vim_plug_version
    curl_cmd="$(sh -c "curl -fLo ${CONFIG_FOLDER}/${CONFIG_NAME}/autoload/plug.vim \
                            --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/${VIM_PLUG_LATEST_VERSION}/plug.vim")"
    curl_cmd_status="$?"
    # Report any curl error to the user
    if [[ "$curl_cmd_status" -ne 0 ]];
    then
        printf "ERROR: Cannot install the plugin manager at the desired location. Please review the log messages.\n"
        exit 1
    fi
    printf "...done\n"

    printf "\n ✓ Setup done"
    printf "\n--------------------\n"

    # Highlight post-action requests to the user
    source_changes "warning"
    install_plugins "warning"
}

perform_cleanup() {
    printf "\n--------------------\n"
    printf "Starting cleanup of nvim config ↺ \n"

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
    printf "\nRemoving alias configuration in \`$DEFAULT_BASH_ALIASES_PATH\`...\n"
    grep -v "alias $ALIAS=\"$CONFIG_FOLDER/$DEFAULT_LOADER_SCRIPT_NAME --custom-config '$ALIAS'\"" "$DEFAULT_BASH_ALIASES_PATH" > "/tmp/.bash_aliases"
    mv "/tmp/.bash_aliases" "$DEFAULT_BASH_ALIASES_PATH"
    grep -v "alias $SHORT_ALIAS=\"$ALIAS\"" "$DEFAULT_BASH_ALIASES_PATH" > "/tmp/.bash_aliases"
    mv "/tmp/.bash_aliases" "$DEFAULT_BASH_ALIASES_PATH"
    printf "...done\n"

    printf "\n ✓ Cleanup done"
    printf "\n--------------------\n"

    # Highlight post-action requests to the user
	source_changes "warning"
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
while true; do
    case "$1" in
        --help|-h)
            print_usage
            exit 1
            ;;

        --branch|-b)
            if [[ -n "$2" ]];
            then
                TARGET_GIT_REPO_BRANCH="$2"
                shift 2
            else
                printf "ERROR: the flag \`--branch|-b\` requires one argument"
                print_usage
                exit 1
            fi
            ;;

        quick-setup)
            if [[ -n "$3" ]]; then
                printf "ERROR: max one argument allowed for the \`quick-setup\` option\n"
                print_usage
                exit 1
            else
                if [[ -n "$2" ]]; then
                    perform_quick_setup "$2"
                    shift 2
                else
                    perform_quick_setup
                    shift 1
                fi
            fi
            break
            ;;

        cleanup)
            if [[ -n "$3" ]]; then
                printf "ERROR: max one argument allowed for the \`perform_cleanup\` option\n"
                print_usage
                exit 1
            else
                if [[ -n "$2" ]]; then
                    perform_cleanup "$2"
                    shift 2
                else
                   perform_cleanup
                    shift 1
                fi
            fi
            break
            ;;

        *)
            printf "ERROR: command invalid (argument \`"$1"\` not valid)\n"
            print_usage
            exit 1
            ;;
    esac
done
