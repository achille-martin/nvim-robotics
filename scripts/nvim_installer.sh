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
BUILD_DESIRED="supported"
OS_DETECTED="unknown"
OS_DISTRIBUTION_DETECTED="unknown"
OS_ARCHITECTURE_DETECTED="unknown"

DEFAULT_LOCAL_FOLDER="$HOME/.local"

# ---- HANDY FUNCTIONS ----

print_usage() {
    multiline_usage_txt="
    Usage: bash $(basename "$0") CMD

    Purpose: Manage the installation and uninstallation of neovim
             on various OS platforms
             (supported platforms: Linux Ubuntu x86_64)

    CMD:
        install [BUILD]    Install latest neovim version
                           for the current OS platform
                           Optional argument: BUILD ([supported]/unsupported)

        uninstall          Remove all neovim versions from current OS platform

        --help, -h         Show this help
    "

    printf "%s" "$multiline_usage_txt"
}

source_changes() {
    printf "\n / ! \\ ACTION: Refresh the state of the environment with the following command\n"
    case "$OS_DETECTED" in
        linux)
            local bashrc_path="$HOME/.bashrc"
            printf "source $bashrc_path\n"
            ;;
        *)
            printf "Not applicable.\n"
            ;;
    esac
}

check_os_type() {
    # Check OS specifications to determine support
    if [[ -n "$OSTYPE" ]];
    then
        if [[ "$OSTYPE" =~ linux|Linux|LINUX ]];
        then
            OS_DETECTED="linux"
            distribution_detected="$(lsb_release -i)"
            if [[ "$distribution_detected" =~ ubuntu|Ubuntu|UBUNTU ]];
            then
                OS_DISTRIBUTION_DETECTED="ubuntu"
                architecture_detected="$(uname -i)"
                if [[ "$architecture_detected" =~ x86_64 ]];
                then
                    OS_ARCHITECTURE_DETECTED="x86_64"
                else
                    printf "ERROR: the architecture \`$architecture_detected\` is not supported.\n"
                    print_usage
                    exit 1
                fi
            else
                printf "ERROR: the distribution \`$distribution_detected\` is not supported.\n"
                print_usage
                exit 1
            fi
        else
            printf "ERROR: the current OS \`$OSTYPE\` is not supported.\n"
            print_usage
            exit 1
        fi
    else
        printf "ERROR: the current OS platform cannot be determined.\n"
        printf "Please verify the supported platforms.\n"
        print_usage
        exit 1
    fi
}

perform_install() {
    # Check and update extra arguments
    printf "Checking extra arguments...\n"
    if [[ -n "$1" ]];
    then
        BUILD_DESIRED="$1"
    fi
    printf "...done\n"

    # Handle the different OS platforms supported
    case "$OS_DETECTED" in

        linux)
            printf "\nEnsuring that there is no neovim version clash...\n"
            if [[ $(which nvim) ]];
            then
                printf "ERROR: a neovim version has been detected.\n"
                printf "Make sure to remove existing versions of neovim before installation\n"
                printf "to avoid clashes.\n"
                print_usage
                exit 1
            fi
            printf "...done\n"

            # Download and install the latest neovim version
            printf "\nMoving to the downloads folder...\n"
            local downloads_folder="$HOME/Downloads"
            if [[ ! -d "$downloads_folder"  ]];
            then
                mkdir -p "$downloads_folder"
            fi
            cd $downloads_folder
            printf "...done\n"

            case "$OS_DISTRIBUTION_DETECTED" in

                ubuntu)
                    printf "\nInstalling necessary dependencies...\n"
                    sudo apt-get install curl
                    printf "...done\n"

                    case "$OS_ARCHITECTURE_DETECTED" in

                        x86_64)
                            printf "\nDownloading neovim archive...\n"
                            if [[ "$BUILD_DESIRED" == "supported" ]];
                            then
                                curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
                            elif [[ "$BUILD_DESIRED" == "unsupported" ]];
                            then
                                curl -LO "https://github.com/neovim/neovim-releases/releases/latest/download/nvim-linux-x86_64.tar.gz"
                            else
                                printf "ERROR: build desired "$BUILD_DESIRED" cannot be processed.\n"
                                print_usage
                                exit 1
                            fi
                            printf "...done\n"

                            printf "\nInstalling neovim in the add-on software location...\n"
                            sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
                            sudo mv /opt/nvim-linux-x86_64 /opt/nvim
                            printf "...done\n"

                            printf "\nAdding neovim path to bashrc (if not there already)...\n"
                            local bashrc_path="$HOME/.bashrc"
                            local bashrc_content=$(sed '' "$bashrc_path")
                            local source_neovim_cmd_txt='export PATH="$PATH:/opt/nvim/bin"'
                            if [[ ! "$bashrc_content" =~ "$source_neovim_cmd_txt" ]];
                            then
                                printf "# Make neovim visible"
                                printf 'export PATH="$PATH:/opt/nvim/bin"' >> "$bashrc_path"
                            fi
                            printf "...done\n"
                            ;;

                        *)
                            printf "ERROR: the current OS architecture \`$OS_ARCHITECTURE_DETECTED\` is not supported.\n"
                            print_usage
                            exit 1
                            ;;

                    esac
                    ;;

                *)
                    printf "ERROR: the distribution \`$OS_DISTRIBUTION_DETECTED\` is not supported.\n"
                    print_usage
                    exit 1
                    ;;

            esac
            ;;

        *)
            printf "ERROR: the current OS \`$OS_DETECTED\` is not supported.\n"
            print_usage
            exit 1
            ;;

    esac
    # Highlight post-action requests to the user
    source_changes
}

perform_uninstall() {
    case "$OS_DETECTED" in

        linux)
            # Remove application added from downloaded package
            printf "Removing application installed from downloaded package...\n"
            sudo rm -rf /opt/nvim*
            printf "...done\n"

   			# Remove user data related to neovim
            printf "Removing user data related to neovim from local folder \`$DEFAULT_LOCAL_FOLDER\`...\n"
            sudo rm -rf "$DEFAULT_LOCAL_FOLDER/share/nvim"
            printf "...done\n"

            case "$OS_DISTRIBUTION_DETECTED" in

                ubuntu)
                    # Remove application installed from apt
                    printf "\nRemoving application installed from apt...\n"
                    sudo apt-get remove neovim
                    printf "...done\n"
                    ;;

                *)
                    printf "ERROR: the distribution \`$OS_DISTRIBUTION_DETECTED\` is not supported.\n"
                    print_usage
                    exit 1
                    ;;

            esac
            ;;


        *)
            printf "ERROR: the current OS \`$OS_DETECTED\` is not supported.\n"
            print_usage
            exit 1
            ;;

    esac

    # Highlight post-action requests to the user
    source_changes
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
        perform_install "$2"
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
