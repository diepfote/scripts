#!/usr/bin/env bash

# BSD 2-Clause License

# Copyright (c) 2020, Florian Begusch
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# * Redistributions of source code must retain the above copyright notice, this
  # list of conditions and the following disclaimer.

# * Redistributions in binary form must reproduce the above copyright notice,
  # this list of conditions and the following disclaimer in the documentation
  # and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



aliases_file=~/.sh_functions
# clear file
echo -n > "$aliases_file"

echo "----------------------"
echo "[>] generating sh functions for fish shell functions"
echo

for file in $(find ~/.config/fish/functions/ -name "*.fish"); do
  basename_no_ext="$(basename "$file" | sed 's/\.[^.]*$//')"
  echo "$basename_no_ext"
  if [[ "$basename_no_ext" =~ commit ]] || [[ "$basename_no_ext" =~ mpv ]]; then
    echo 'function '"$basename_no_ext"' {  commands="'\''$@'\''"; fish -c "'"$basename_no_ext"' $commands"'\; } >> "$aliases_file"
  elif [ "$basename_no_ext" = unset ] || [ "$basename_no_ext" = n ]; then
    :
    # 1) do not replace bash's unset!
    # 2) nnn cd on quit uses different functions for fish and bash!
  else
    echo 'function '"$basename_no_ext"' {  commands="$@"; fish -c "'"$basename_no_ext"' $commands"'\; } >> "$aliases_file"
  fi
done
echo -e "----------------------\n"

