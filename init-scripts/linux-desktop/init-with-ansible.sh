#!/bin/sh

scriptdir="$(cd -- "$(dirname -- "$0")" && pwd -P)" >/dev/null 2>&1
exec "${scriptdir}/ansible/run-playbooks.sh"
