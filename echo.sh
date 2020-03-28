#!/bin/sh

set -eu

if [ "${ZSH_VERSION:-}" ]; then
  puts() {
    IFS=" $IFS"; builtin print -nr -- "${*:-}"; IFS=${IFS#?}
  }
  putsn() {
    [ $# -gt 0 ] && puts "$@"; builtin print -r
  }
elif [ "${KSH_VERSION:-}" ]; then
  puts() {
    IFS=" $IFS"; command print -nr -- "${*:-}"; IFS=${IFS#?}
  }
  putsn() {
    [ $# -gt 0 ] && puts "$@"; command print -r
  }
elif [ "${POSH_VERSION:-}" ]; then
  puts() {
    IFS=" $IFS"; set -- "${*:-}\\" "" "\\"; IFS=${IFS#?}
    if [ "$1" = "-n\\" ]; then
      builtin echo -n -; builtin echo -n n; return 0
    fi
    if [ "${3#*\\}" ]; then
      while [ "$1" ]; do set -- "${1#*\\\\}" "$2${2:+\\\\}${1%%\\\\*}"; done
    else
      while [ "$1" ]; do set -- "${1#*\\}" "$2${2:+\\\\}${1%%\\*}"; done
    fi
    builtin echo -n "$2"
  }
  putsn() {
    [ $# -gt 0 ] && puts "$@"; builtin echo
  }
else
  puts() {
    PATH="${PATH:-}:/usr/bin:/bin"
    IFS=" $IFS"; printf '%s' "$*"; IFS=${IFS#?}
    PATH=${PATH%:/usr/bin:/bin}
  }
  putsn() {
    PATH="${PATH:-}:/usr/bin:/bin"
    IFS=" $IFS"; printf '%s\n' "$*"; IFS=${IFS#?}
    PATH=${PATH%:/usr/bin:/bin}
  }
fi

echo() {
  if [ "${1:-}" = "-n" ] && shift; then
    [ $# -eq 0 ] || puts "$@"
  else
    [ $# -eq 0 ] || putsn "$@"
  fi
}
