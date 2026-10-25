#!/bin/sh
# catalogue.sh <out dir>: the render catalogue on dusk and Moss (catalogue/catalogue.qml run inside the mock copy of the
# shell tree, with this repo's qml folder on the import path).
set -e
out=${1:?usage: catalogue.sh <out dir>}
here=$(dirname "$(readlink -f "$0")")/..
mocks=${TACIT_MOCKS:-$HOME/.cache/tacit-mocks}
mkdir -p "$out"
cp "$here/catalogue/catalogue.qml" "$mocks/tacit/kit-catalogue.qml"
for pal in "dusk dusk" "moss Moss"; do
  for page in ${PAGES:-1 2 3 4 5 6 7 8 9 10}; do
    set -- $pal
    CATALOGUE_PAGE=$page XDG_STATE_HOME=$mocks/state-$1 MOCK_WALL=$2 CATALOGUE_OUT="$out/$1" QML_IMPORT_PATH="$here/qml" \
        env -u QT_LOGGING_RULES QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=rhi QSG_RHI_BACKEND=opengl QT_FORCE_STDERR_LOGGING=1 \
        timeout 90 qs -p "$mocks/tacit/kit-catalogue.qml" 2>&1 | grep -E "ERROR|caused by|qml:|Tacit.Kit|TypeError|ReferenceError" | head -8 || true
  done
done
ls "$out"
