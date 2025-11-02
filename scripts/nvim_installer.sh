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

# ---- EXTERNAL SOURCES ----

# WARNING: the external sources need to be located in the same folder
# as this script
if [[ $BASH_SOURCE == */* ]]; then
    cd_cmd="$(cd -- "${BASH_SOURCE%/*}/")"
fi
source helper_functions.sh

# ---- HANDY VARIABLES ----

NEOVIM_TAG="latest"

# ---- HANDY FUNCTIONS ----

print_usage() {
    multiline_usage_txt="
    Usage: bash $(basename "$0") CMD

    Purpose: Manage the installation and uninstallation of neovim
             on various OS platforms
             (supported platforms: Linux Ubuntu x86_64)

    CMD:
        install             Install neovim \`$NEOVIM_TAG\` version
                            for the current OS platform
                            Note: automatically installs
                            the \"unsupported\" release of neovim if necessary

        uninstall           Remove all neovim versions from current OS platform

        --help, -h          Show this help
    "

    printf "%s" "$multiline_usage_txt"
}

perform_install() {
    printf "\n--------------------\n"
    printf "Starting neovim installation ↺ \n"
    sleep 1

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
            if [[ ! -d "$DEFAULT_DOWNLOADS_FOLDER"  ]];
            then
                mkdir -p "$DEFAULT_DOWNLOADS_FOLDER"
            fi
            cd $DEFAULT_DOWNLOADS_FOLDER
            printf "...done\n"

            case "$OS_DISTRIBUTION_DETECTED" in

                ubuntu)
                    printf "\nInstalling necessary dependencies...\n"
                    sudo apt-get install curl
                    printf "...done\n"

                    case "$OS_ARCHITECTURE_DETECTED" in

                        x86_64)
                            printf "\nDownloading neovim archive...\n"
                            # Adapt the download method
                            # depending on the support status
                            # of the distribution major release
                            if [[ "$IS_OS_PLATFORM_SUPPORTED" -eq 1 && "$IS_DISTRIBUTION_MAJOR_RELEASE_SUPPORTED" -eq 1 ]];
                            then
                                local curl_cmd="$(curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz")"
                            elif [[ "$IS_OS_PLATFORM_SUPPORTED" -eq 1 && "$IS_DISTRIBUTION_MAJOR_RELEASE_SUPPORTED" -eq 0 ]];
                            then
                                local curl_cmd="$(curl -LO "https://github.com/neovim/neovim-releases/releases/latest/download/nvim-linux-x86_64.tar.gz")"
                            else
                                printf "ERROR: There has been a problem\n"
                                printf "while trying to determine the support status of the distribution major release.\n"
                                printf "Not downloading any archive. Please review the log messages.\n"
                                exit 1
                            fi
                            local curl_cmd_status="$?"
                            # Report any curl error to the user
                            if [[ "$curl_cmd_status" -ne 0 ]];
                            then
                                printf "ERROR: Cannot download the neovim archive. Please review the log messages.\n"
                                exit 1
                            fi
                            printf "...done\n"

                            printf "\nInstalling neovim in the add-on software location...\n"
                            sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
                            sudo mv /opt/nvim-linux-x86_64 /opt/nvim
                            printf "...done\n"

                            printf "\nAdding neovim path to bashrc (if not there already)...\n"
                            local bashrc_content=$(sed '' "$DEFAULT_BASHRC_PATH")
                            local source_neovim_cmd_txt='export PATH="$PATH:/opt/nvim/bin"'
                            if [[ ! "$bashrc_content" =~ "$source_neovim_cmd_txt" ]];
                            then
                                printf "\n" >> "$DEFAULT_BASHRC_PATH"
                                printf "# Make neovim visible" >> "$DEFAULT_BASHRC_PATH"
                                printf "\n" >> "$DEFAULT_BASHRC_PATH"
                                printf 'export PATH="$PATH:/opt/nvim/bin"' >> "$DEFAULT_BASHRC_PATH"
                                printf "\n" >> "$DEFAULT_BASHRC_PATH"
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

    printf "\n ✓ Installation done"
    printf "\n--------------------\n"

    # Highlight post-action requests to the user
    source_changes
}

perform_uninstall() {
    printf "\n--------------------\n"
    printf "Starting neovim uninstallation ↺ \n"
    sleep 1

    # Handle the different OS platforms supported
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

    printf "\n ✓ Uninstallation done"
    printf "\n--------------------\n"

    # Highlight post-action requests to the user
    source_changes
}

# ---- MAIN ----

# Ensure that the OS platform is supported
check_os_specifications

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
        perform_install
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
