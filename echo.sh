#!/bin/sh

set -eu

if [ "${ZSH_VERSION:-}" ]; then
  # zsh all versions: "print" is built-in.
  # zsh 3.1.9, 4.0.4: "printf" is NOT built-in.
  puts() {
    IFS=" $IFS"; builtin print -nr -- "${*:-}"; IFS=${IFS#?}
  }
  putsn() {
    [ $# -gt 0 ] && puts "$@"; builtin print -r
  }
elif [ "${KSH_VERSION:-}" ]; then
  # ksh, mksh, pdksh all versions: "print" is built-in.
  # mksh some versions: "printf" is NOT built-in.
  # loksh, pdksh: "printf" is NOT built-in.
  puts() {
    IFS=" $IFS"; command print -nr -- "${*:-}"; IFS=${IFS#?}
  }
  putsn() {
    [ $# -gt 0 ] && puts "$@"; command print -r
  }
elif [ "${POSH_VERSION:-}" ]; then
  # posh: "printf" and "print" is NOT built-in.
  puts() {
    IFS=" $IFS"; set -- "${*:-}\\" "" "\\"; IFS=${IFS#?}
    if [ "$1" = "-n\\" ]; then
      builtin echo -n -; builtin echo -n n; return 0
    fi
    if [ "${3#*\\}" ]; then
      # posh 0.3.14, 0.5.4: workaround for old posh bug
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
  # assume built-in "printf", but even works otherwise.
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
    puts "${@:-}"
  else
    putsn "${@:-}"
  fi
}
