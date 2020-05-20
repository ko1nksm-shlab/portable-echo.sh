#!/bin/sh

set -eu

puts() {
  printf '' && return 0
  if print -nr -- ''; then
    [ "${ZSH_VERSION:-}" ] && return 1 || return 2
  fi
  if [ "${POSH_VERSION:-}" ]; then
    [ "${1#*\\}" ] && return 3 || return 4
  fi
  return 9
}
# shellcheck disable=SC2030,SC2123
( PATH=""; puts "\\" ) 2>/dev/null &&:
case $? in
  0)
    # Use built-in 'printf'.
    puts() { IFS=" $IFS"; printf '%s' "${*:-}"; IFS=${IFS#?}; }
    putsn() { IFS=" $IFS"; printf '%s\n' "${*:-}"; IFS=${IFS#?}; }
    ;;
  1)
    # zsh 3.1.9, 4.0.4
    puts() { builtin print -nr -- "${@:-}"; }
    putsn() { builtin print -r -- "${@:-}"; }
    ;;
  2)
    # ksh88, mksh (depends on compile option), OpenBSD ksh (loksh, oksh), pdksh
    puts() { command print -nr -- "${@:-}"; }
    putsn() { command print -r -- "${@:-}"; }
    ;;
  3)
    # posh 0.3.14, 0.5.4 + workaround for parameter expansion bug
    puts() {
      if [ $# -eq 1 ] && [ "$1" = "-n" ]; then
        builtin echo -n -; builtin echo -n n; return 0
      fi
      IFS=" $IFS"; set -- "${*:-}\\" ""; IFS=${IFS#?}
      while [ "$1" ]; do set -- "${1#*\\\\}" "$2${2:+\\\\}${1%%\\\\*}"; done
      builtin echo -n "$2"
    }
    putsn() { [ $# -gt 0 ] && puts "$@"; builtin echo; }
    ;;
  4)
    # posh
    puts() {
      if [ $# -eq 1 ] && [ "$1" = "-n" ]; then
        builtin echo -n -; builtin echo -n n; return 0
      fi
      IFS=" $IFS"; set -- "${*:-}\\" ""; IFS=${IFS#?}
      while [ "$1" ]; do set -- "${1#*\\}" "$2${2:+\\\\}${1%%\\*}"; done
      builtin echo -n "$2"
    }
    putsn() { [ $# -gt 0 ] && puts "$@"; builtin echo; }
    ;;
  9)
    # Fallback using external 'printf'. It works even PAHT is empty.
    puts() {
      # shellcheck disable=SC2031
      PATH="${PATH:-}:/usr/bin:/bin"
      IFS=" $IFS"; printf '%s' "$*"; IFS=${IFS#?}
      PATH=${PATH%:/usr/bin:/bin}
    }
    putsn() {
      PATH="${PATH:-}:/usr/bin:/bin"
      IFS=" $IFS"; printf '%s\n' "$*"; IFS=${IFS#?}
      PATH=${PATH%:/usr/bin:/bin}
    }
    ;;
esac

# Portable echo that supports only -n
echo() {
  if [ "${1:-}" = "-n" ] && shift; then
    puts "${@:-}"
  else
    putsn "${@:-}"
  fi
}
