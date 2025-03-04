#!/bin/bash
set -e

# If no arguments passed, run dbt debug
if [[ -z "$1" ]]; then
    dbt debug
else
    exec "$@"
fi
