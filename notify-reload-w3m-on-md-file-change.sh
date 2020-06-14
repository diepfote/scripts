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

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


_get_w3m_pane_id() {

  local pane_to_reload="$(for pane_pid in $(tmux list-panes -F '#{pane_pid}'); do \
    ps -f --ppid "$pane_pid" \
    | awk '{ print substr($0, index($0,$8))}' \
    | grep /w3m 1>/dev/null && itis=true; \
      set +u; [ "$itis" = true ] \
      && echo "$pane_pid"; itis=false; set -u ; done)"

  tmux list-panes -F "#{pane_pid} #{pane_id}" \
    | grep "$pane_to_reload" | cut -d ' ' -f2
}

watch_dir="$1"

while file=$(inotifywait -e modify --format "%w%f" "$watch_dir"); do

  EXT=$(echo "$file" | \
    python3 -c "filename = input(); print(filename.rsplit('.', 1)[1])")
  if [ "$EXT" = "md" ] || \
     [ -n "$(echo "$file" | grep goutputstream)" ] || \
     [ "$EXT" = "MD" ] || \
     [ "$EXT" = "jpg" ] || \
     [ "$EXT" == "png" ]; then

    tmux send-keys -t "$(_get_w3m_pane_id)" \
      q y C-m "pandoc $file | w3m -T text/html" C-m

  fi

done

