#!/bin/sh
set -eu -- sh ash bash bosh pbosh dash posh yash zsh
set -- "$@" ksh ksh88 ksh93 ksh2020 lksh mksh loksh oksh pdksh
run() { echo "$@"; "$@"; }
for shell; do
  type "$shell" >/dev/null 2>&1 || continue
  run shellspec -s "$shell" --no-quick
done
echo Done
