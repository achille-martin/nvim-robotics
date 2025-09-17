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


# ---- HANDY FUNCTIONS ----

print_usage() {
    multiline_usage_txt="
    Usage: bash $(basename "$0") CMD

    Purpose: Manage the neovim configuration operations

    CMD:
        quick-setup        Setup the nvim-robotics configuration
                           as it is provided in the repo

        --help, -h         Show this help
    "

    printf "%s" "$multiline_usage_txt"
}

perform_quick_setup() {
    printf "Function not defined yet.\n"
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
        perform_quick_setup
        ;;

    *)
        printf "ERROR: first argument not valid\n"
        print_usage
        exit 1
        ;;
esac
