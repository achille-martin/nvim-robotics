#!/bin/bash -i

# Released under MIT License

# Copyright (c) 2026 Achille MARTIN

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

repo_name="nvim-robotics"
cmd_alias="$repo_name"
health_log_filename="${repo_name}_health.log"

# ---- MAIN ----

# Perform full Neovim health check
# and identify errors
mkdir_cmd="$(mkdir -p "/tmp/$repo_name-tests")"
cd "/tmp/$repo_name-tests"
if [[ ! "${BASH_ALIASES[$cmd_alias]}" ]];
then
    printf "\nERROR: alias $cmd_alias not found.\n"
    exit 1
fi
checkhealth_cmd="$(nvim-robotics --headless -c "checkhealth" -c "set modifiable" -c "w! $health_log_filename" -c qall)"
checkhealth_cmd_status="$?"
if [[ "$checkhealth_cmd_status" -ne 0 ]];
then
    printf "\nERROR: Neovim checkhealth command failed.\n"
    exit 1
fi
grep_cmd="$(grep -ir "error" "$health_log_filename")"
grep_cmd="$?"
if [[ "$grep_cmd_status" -ne 0 ]];
then
    printf "\nERROR: errors found in health log.\n"
    exit 1
fi

cd -
printf "\n\nSUCCESS: all health check tests passed.\n\n"



