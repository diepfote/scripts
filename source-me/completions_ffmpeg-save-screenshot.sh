#!/usr/bin/env bash

_ffmpeg-normalize-audio-for-video-or-audio_completions()
{
  COMPREPLY=()
  index=$COMP_CWORD
  local cur_word="${COMP_WORDS[$index]}"
  prev_index=$((index - 1))
  local prev_word="${COMP_WORDS[$prev_index]}"


  COMPREPLY=()
  case "${prev_word}" in
    *)
      while IFS='' read -r line; do
        COMPREPLY+=("$line")
      done < <(compgen -W "$(echo -e '-t\n--jpg\n--png\n--name-screenshot')" -- "$cur_word")
      ;;
  esac

}

complete -F _w-pkg-update_completions 'w-pkg-update'

complete -F _ffmpeg-normalize-audio-for-video-or-audio_completions ffmpeg-normalize-audio-for-video-or-audio-file
