#!/bin/sh
# grab.sh <app.qml> [out dir]: run the app offscreen once per palette in tools/palettes/ and save what its window draws
# as <out>/<palette>.png (2x, transparent where the window is see-through). GRAB_SETTLE=<ms> waits longer before the
# picture (default 1500); QT_SCALE_FACTOR=1 for 1x.
set -e
app=$(readlink -f "${1:?usage: grab.sh <app.qml> [out dir]}"); out=$(readlink -f "${2:-.}")
here=$(dirname "$(readlink -f "$0")")
mkdir -p "$out"
state=$(mktemp -d); trap 'rm -rf "$state"' EXIT
for pal in "$here"/palettes/*.json; do
    name=$(basename "$pal" .json)
    mkdir -p "$state/$name/quickshell/user/generated"
    cp "$pal" "$state/$name/quickshell/user/generated/colors.json"
    XDG_STATE_HOME=$state/$name GRAB_APP=$app GRAB_OUT=$out/$name.png QML_IMPORT_PATH="$here/../qml${QML_IMPORT_PATH:+:$QML_IMPORT_PATH}" \
        QT_SCALE_FACTOR=${QT_SCALE_FACTOR:-2} QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=rhi QSG_RHI_BACKEND=opengl QT_FORCE_STDERR_LOGGING=1 \
        timeout 60 qs -p "$here/grab.qml" 2>&1 | grep -E "GRAB|ERROR|TypeError|ReferenceError" || true
done
