#!/bin/sh
# behaviour.sh: run tools/behaviour.qml offscreen (dusk palette) and print its checks.
set -e
here=$(dirname "$(readlink -f "$0")")
state=$(mktemp -d); trap 'rm -rf "$state"' EXIT
mkdir -p "$state/quickshell/user/generated"
cp "$here/palettes/dusk.json" "$state/quickshell/user/generated/colors.json"
env -u WAYLAND_DISPLAY XDG_STATE_HOME=$state QML_IMPORT_PATH="$here/../qml" QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=rhi QSG_RHI_BACKEND=opengl \
    QT_FORCE_STDERR_LOGGING=1 timeout 120 qs -p "$here/behaviour.qml" 2>&1
