#!/usr/bin/env bash

_pkg-update_completions() {
  _w-pkg-update_completions "$@"

  __os-independent-updates_completions "$@"

  _pkg-update_completions-return "$@"
}

_w-pkg-update_completions()
{
  completions=()
  completions+=(-h)
  completions+=(-g)
  completions+=(-r)
  completions+=(--reinstall-xcode)
  completions+=(--no-lima)
  completions+=(--no-disable-remote-login)
  completions+=(--no-mac-os-updates)
  completions+=(--no-update-repos)
  completions+=(--mac-os-updates-only)

  _pkg-update_completions-return "$@"

}

complete -F _w-pkg-update_completions 'w-pkg-update'
complete -F _pkg-update_completions 'pkg-update'

