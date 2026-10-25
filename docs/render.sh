#!/bin/sh
# render.sh <page> <out dir>: a docs page's figures (docs/figures/<page>.qml) at twice the size, on dusk and Moss, into
# <out dir>/<palette>/<figure>.png. Needs nothing but this checkout, Quickshell 0.3+ (Qt 6.7+) and a GPU-less offscreen Qt.
# Each palette runs in a private directory holding only the figure and lib/Doc*.qml, with the palette written as the
# shell would (tools/palettes/<palette>.json), so renders at the same time never overwrite each other's files.
# The wallpapers and pictures the figures use are docs/assets/ (FIGURE_ASSETS).
set -e
page=${1:?usage: render.sh <page> <out dir>}; out=${2:?usage: render.sh <page> <out dir>}
here=$(dirname "$(readlink -f "$0")")/..
run=$(mktemp -d /tmp/tacit-figure.XXXXXX); trap 'rm -rf "$run"' EXIT
cp "$here"/docs/figures/lib/Doc*.qml "$run/"
cp "$here/docs/figures/$page.qml" "$run/figure.qml"
mkdir -p "$run/config"
for pal in dusk moss; do
    mkdir -p "$out/$pal" "$run/state-$pal/quickshell/user/generated"
    cp "$here/tools/palettes/$pal.json" "$run/state-$pal/quickshell/user/generated/colors.json"
    if [ "$page" = your-first-app ]; then   # the tutorial app, run as it is, offscreen; its figure lays the picture on the wallpaper
        mkdir -p "$run/raw/$pal"
        XDG_STATE_HOME=$run/state-$pal XDG_CONFIG_HOME=$run/config FIGURE_OUT=$run/raw/$pal FIGURE_APP="$here/docs/examples/downloads.qml" \
            QML_IMPORT_PATH="$here/qml" QT_SCALE_FACTOR=2 \
            env -u QT_LOGGING_RULES QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=rhi QSG_RHI_BACKEND=opengl QT_FORCE_STDERR_LOGGING=1 \
            timeout 60 qs -p "$here/docs/figures/lib/first-run.qml" 2>&1 | grep -E "ERROR|DUMP" | head -4 || true
    fi
    FIGURE_ASSETS="$here/docs/assets" FIGURE_RAW=$run/raw/$pal FIGURE_SRC="$here/docs/figures" XDG_STATE_HOME=$run/state-$pal XDG_CONFIG_HOME=$run/config MOCK_WALL=$pal FIGURE_OUT="$out/$pal" QML_IMPORT_PATH="$here/qml" QT_SCALE_FACTOR=2 \
        env -u QT_LOGGING_RULES QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=rhi QSG_RHI_BACKEND=opengl QT_FORCE_STDERR_LOGGING=1 \
        timeout 180 qs -p "$run/figure.qml" 2>&1 | grep -E "ERROR|caused by|TypeError|ReferenceError|DUMP" | head -${LINES_MAX:-8} || true
done
ls "$out"/dusk | wc -l
