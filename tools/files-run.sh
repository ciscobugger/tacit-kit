#!/bin/sh
# files-run.sh start [tree] | shot <name> | call <fn> [args] | stop
# Files from a shell tree (default the files-kit worktree) in a hidden headless Weston with its own XDG folders,
# runtime dir and session bus: the owner's shell, Hyprland and files never see it. PAL=dusk|moss picks the palette
# (the mock state's colours); the home is a demo with Downloads from ~/.cache/tacit-mocks/files-demo. `shot` saves the
# window's content laid over the palette's blurred wallpaper (what the compositor would show) as $T/out/<name>.png.
# Several can run at once: FK_T (its folder), FK_SOCK (its Weston socket) and FK_ENTRY (an entry file with more IPC)
# keep them apart.
T=${FK_T:-/var/tmp/files-kit-test}
SOCK=${FK_SOCK:-fk}
X=$T/xdg
PAL=${PAL:-dusk}
here=$(dirname "$(readlink -f "$0")")
ENTRY=${FK_ENTRY:-$here/files-entry.qml}
Q="env WAYLAND_DISPLAY=$SOCK XDG_RUNTIME_DIR=$X/run XDG_STATE_HOME=$X/state XDG_CONFIG_HOME=$X/config qs -p $T/tacit/files-entry.qml"
case "$1" in
start)
    tree=${2:-/var/tmp/files-kit}
    mkdir -p "$T/out"
    rsync -a --delete --exclude .git --exclude native --exclude port --exclude '__pycache__' "$tree/" "$T/tacit/"
    cp "$ENTRY" "$T/tacit/files-entry.qml"
    rm -rf "$X" "$T/home"; mkdir -p "$X/config" "$X/data" "$X/state/quickshell/user" "$X/cache" "$X/run" "$T/home" && chmod 700 "$X/run"
    cp -a --sparse=always "${TACIT_MOCKS:-$HOME/.cache/tacit-mocks}/files-demo/." "$T/home/"
    mkdir -p "$T/home/Documents" "$T/home/Music" "$T/home/Pictures" "$T/home/Videos" "$T/home/Desktop"
    # the owner's fonts and font settings (Tacit Sans lives in ~/.local/share/fonts; fontconfig reads
    # $XDG_DATA_HOME/fonts), read only
    mkdir -p "$T/home/.local/share" "$X/config"
    ln -s "$HOME/.local/share/fonts" "$T/home/.local/share/fonts"
    ln -s "$HOME/.local/share/fonts" "$X/data/fonts"
    cp -a "$HOME/.config/fontconfig" "$X/config/"
    cp -a "$HOME/.config/illogical-impulse" "$X/config/"
    cp -a "${TACIT_MOCKS:-$HOME/.cache/tacit-mocks}/state-$PAL/quickshell/user/generated" "$X/state/quickshell/user/"
    env -u HYPRLAND_INSTANCE_SIGNATURE -u WAYLAND_DISPLAY -u DISPLAY -u DBUS_SESSION_BUS_ADDRESS \
        XDG_CONFIG_HOME=$X/config XDG_STATE_HOME=$X/state XDG_CACHE_HOME=$X/cache XDG_RUNTIME_DIR=$X/run \
        XDG_DATA_HOME=$X/data HOME=$T/home QML_IMPORT_PATH=$HOME/.local/lib/qml \
        setsid dbus-run-session -- sh -c "
          weston --backend=headless --renderer=gl --socket=$SOCK --width=${W:-1440} --height=${H:-900} --scale=${SCALE:-1} --shell=kiosk >$T/weston.log 2>&1 &
          sleep 1.5
          WAYLAND_DISPLAY=$SOCK exec qs -n -p $T/tacit/files-entry.qml" > "$T/log.txt" 2>&1 &
    echo $! > "$T/pid"
    for i in $(seq 60); do $Q ipc call pt count >/dev/null 2>&1 && { echo "up"; exit 0; }; sleep 0.25; done
    echo "did not come up"; grep -E 'ERROR|caused' "$T/log.txt" | tail -5; exit 1 ;;
shot)
    raw=$T/out/$2-raw.png
    $Q ipc call pt shot "$raw"; sleep 0.8
    wall=dusk; [ "$PAL" = moss ] && wall=Moss
    # the window on the wallpaper with room around it, as on the desktop (a frame-filling window showed the
    # wallpaper only in its four corners, which read as colour leaking at the edges)
    m=${MARGIN:-40}
    size=$(magick identify -format '%[fx:w+2*'$m']x%[fx:h+2*'$m']' "$raw")
    magick "${TACIT_MOCKS:-$HOME/.cache/tacit-mocks}/music/wall-$wall-blur.jpg" -resize "$size^" -gravity center -extent "$size" \
        "$raw" -gravity northwest -geometry +$m+$m -composite "$T/out/$2.png" && echo "$T/out/$2.png" ;;
stop)
    fusermount3 -u "$X/run/gvfs" 2>/dev/null
    [ -f "$T/pid" ] && kill -- "-$(cat "$T/pid")" 2>/dev/null
    rm -f "$T/pid"; sleep 0.3; echo stopped ;;
call)
    shift; $Q ipc call pt "$@" ;;
esac
