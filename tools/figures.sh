#!/bin/sh
# figures.sh <page> <out dir>: the same as docs/render.sh (kept for the name the docs briefs use).
exec sh "$(dirname "$(readlink -f "$0")")/../docs/render.sh" "$@"
