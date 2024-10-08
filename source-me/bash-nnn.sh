#!/usr/bin/env bash


# NNN_COLORS: string of color numbers for each context, e.g.:
#
 # 8 color numbers:
 # 0-black, 1-red, 2-green, 3-yellow, 4-blue (default), 5-magenta, 6-cyan, 7-white
export NNN_COLORS=2136  # v3.2
export NNN_TRASH=1
# jump locations
export NNN_BMS="d:~/Documents;h:~;D:~/Downloads;E:/etc/;v:~/Videos;V:/tmp/automounts/fat-drive-mount/Media/Video-Files/Videos;m:~/Movies"
export NNN_FIFO=/tmp/nnn.fifo
# curl -Ls https://raw.githubusercontent.com/jarun/nnn/v3.2/plugins/getplugs | sh
export NNN_PLUG='p:preview-tui;v:imgview;t:imgthumb'

_ask-to-empty-trash () {
  local dir="$1"
  if [ ! -e "$dir/files" ]; then
    return
  fi

  ls -alh "$dir"/files

  echo "Do you want to empty the trash in $dir?"
  if yesno; then
    set -u
    rm -rf "${dir:?}"/*
    set +u
  fi
}

n_empty-trash () {
  _ask-to-empty-trash ~/.local/share/Trash

  _df=/opt/homebrew/opt/coreutils/libexec/gnubin/df
  if [ "$(uname)" != Darwin ]; then
    # shellcheck disable=SC2209
    _df=df
  fi

  local trash_dirs=()
  while read -r line; do
    # Linux: default id for first user
    trash_dirs+=("$line"/.Trash-1000)
    # Darwin: default id for first user
    trash_dirs+=("$line"/.Trash-501)
  done < <("$_df" --output=target)

  for trash_dir in "${trash_dirs[@]}"; do
    if [ -d "$trash_dir" ]; then
      _ask-to-empty-trash "$trash_dir"
    fi
    set +x
  done
}

n-rsync () {
  # @2024-04-09
  # copy all files in selection to directory.
  # this uses rsync instead of `cp` or `mv`
  # which is nnn v3.2 does
  while read -r file; do
    rsync -av "$file" "$@"
  done < <(tr '\0' '\n' < ~/.config/nnn/.selection; echo)
}

n ()
{
#BSD 2-Clause License

#Copyright (c) 2014-2016, Lazaros Koromilas <lostd@2f30.org>
#Copyright (c) 2014-2016, Dimitris Papastamos <sin@2f30.org>
#Copyright (c) 2016-2020, Arun Prakash Jana <engineerarun@gmail.com>
#All rights reserved.

#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are met:

#* Redistributions of source code must retain the above copyright notice, this
  #list of conditions and the following disclaimer.

#* Redistributions in binary form must reproduce the above copyright notice,
  #this list of conditions and the following disclaimer in the documentation
  #and/or other materials provided with the distribution.

#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
#FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi

    n_empty-trash
}

