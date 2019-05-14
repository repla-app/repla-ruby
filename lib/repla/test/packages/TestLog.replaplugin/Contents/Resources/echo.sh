#!/usr/bin/env bash

set -e

echo 'Testing log error' >&2
printf "\n" >&2
echo 'Testing log message'
echo 'ERROR ' >&2
echo 'MESSAGE '
echo
printf "\t"
echo 'Done'
printf "\n"

