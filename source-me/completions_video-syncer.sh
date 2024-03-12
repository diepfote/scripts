#!/usr/bin/env bash

_video-syncer_completions () {
  completions=()

  completions+=(--no-fetch)
  completions+=(--dry-run)

  _pkg-update_completions-return "$@"
}

complete -F _video-syncer_completions video-sync
complete -F _video-syncer_completions video-sync-mpv-watch-later-files
