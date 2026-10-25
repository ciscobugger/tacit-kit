#!/bin/sh
# parity.sh <shell tree> <out prefix>: every Tacit token as that shell tree resolves it, on three palettes (the live
# one, dusk, Moss), into <out prefix>-<palette>.txt. Runs in a throwaway copy of the tree with services/Idle.qml's
# idle inhibitor taken out (its PanelWindow cannot load offscreen); the tree itself is not touched.
set -e
tree=$1; out=$2
[ -d "$tree/modules/common" ] && [ -n "$out" ] || { echo "usage: parity.sh <shell tree> <out prefix>" >&2; exit 2; }
here=$(dirname "$(readlink -f "$0")")
run=$(mktemp -d /tmp/kit-parity-run.XXXXXX)
trap 'rm -rf "$run"' EXIT
cp -r "$tree"/. "$run"/
rm -rf "$run/.git"
python3 - "$run/services/Idle.qml" <<'EOF'
import re, sys
p = sys.argv[1]; s = open(p).read()
s = s.replace("property alias inhibit: idleInhibitor.enabled\n    inhibit: false", "property bool inhibit: false")
a = s.find("    IdleInhibitor {")
if a >= 0:
    depth, i = 0, s.index("{", a)
    while True:
        depth += {"{": 1, "}": -1}.get(s[i], 0)
        i += 1
        if depth == 0:
            break
    s = s[:a] + s[i:]
open(p, "w").write(s)
EOF
cp "$here/dump-tacit.qml" "$run/dump-tacit.qml"
for pal in live dusk moss; do
    case $pal in live) st=$HOME/.local/state ;; *) st=${TACIT_MOCKS:-$HOME/.cache/tacit-mocks}/state-$pal ;; esac
    XDG_STATE_HOME=$st env -u QT_LOGGING_RULES QT_QPA_PLATFORM=offscreen QT_FORCE_STDERR_LOGGING=1 \
        timeout 60 qs -p "$run/dump-tacit.qml" 2>&1 | grep -o "DUMP.*" > "$out-$pal.txt" || true
    echo "$pal: $(wc -l < "$out-$pal.txt") tokens"
done
