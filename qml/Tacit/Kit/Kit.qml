// SPDX-License-Identifier: LGPL-3.0-or-later
pragma Singleton
import QtQuick
import Quickshell
import "symbols.js" as Names

// Tacit.Kit: what every part reads. `tokens` holds the roles and values of tokens.json. By default they are Live:
// the colours follow the user's wallpaper as the shell's do, read from the palette the shell generates; until that is
// read, and on a system without it, Defaults (one palette, fixed). The shell's own surfaces hand in its Tacit instead
// (Kit.tokens = Tacit). `focusVisible` is the keyboard focus ring's switch: on from the first key, off at the next pointer
// press, one for the whole app. `reducedMotion` turns every motion off; `motion(name)` is a motion token by name, the kit's own
// when the app's tokens predate it; `watchKeys(window)` makes the first Tab show the ring.
// Quickshell's Singleton, not a QtObject: only its singletons get Quickshell's file reading (Live's palette)
Singleton {
    id: kit

    // children, not property values: Quickshell starts Live's palette files only through the child list
    Live { id: liveTokens }
    readonly property QtObject live: liveTokens
    readonly property Defaults fallback: Defaults {}
    property QtObject tokens: live.ready ? live : fallback
    property bool focusVisible: false
    // Reduced motion: every motion of the kit takes 0 ms and the two endless stretches (the header's reading line, an
    // endless Progress) stand still. For now it is read from the environment, TACIT_REDUCED_MOTION=1; an app may also set it
    // (Kit.reducedMotion = true). A setting that reads the user's choice will replace the variable.
    property bool reducedMotion: Quickshell.env("TACIT_REDUCED_MOTION") === "1"

    // the type travels with the module, so an app looks right on a computer without Tacit's fonts installed (on Tacit
    // the same families are installed already)
    readonly property FontLoader sans: FontLoader { source: Qt.resolvedUrl("fonts/TacitSans.ttf") }
    readonly property FontLoader sansDisplay: FontLoader { source: Qt.resolvedUrl("fonts/TacitSansDisplay.ttf") }
    readonly property FontLoader code: FontLoader { source: Qt.resolvedUrl("fonts/TacitCode.ttf") }
    readonly property FontLoader symbolLine: FontLoader { source: Qt.resolvedUrl("fonts/TacitSymbols.ttf") }
    readonly property FontLoader symbolFill: FontLoader { source: Qt.resolvedUrl("fonts/TacitSymbolsFill.ttf") }

    // A duration from the motion tokens as it runs now: 0 with reduced motion. Every animation of a part goes through it.
    function ms(duration) {
        return kit.reducedMotion ? 0 : duration;
    }

    // Pointer targets: a part is at least 24 px each way to press (WCAG 2.2, 2.5.8). The kit's are 28 (a jump index mark,
    // the filter's ✕), 32 (a rail row, a tab, the search's clear), 36 (a symbol button, a field), 40 and up (actions,
    // list rows). Two are smaller: InlineLink is the words of a sentence (a link inside text is the standard's exception), and
    // a folded JumpIndex's dot, which has 12 between two 24 px marks (18 apart cannot hold more).
    // The first Tab. Every kit part turns `focusVisible` on from its own key handler, so the ring shows once a key has been
    // pressed on a part; a Tab pressed on a plain item (or with nothing focused) lands on a part before any part has seen a
    // key, and no ring would show. An app calls `Kit.watchKeys(window)` once for each window (in its Component.onCompleted):
    // a key that nothing below handled, Tab included, reaches the window's content item, and that turns the ring on. The
    // pointer still turns it off only on a kit part; a click on something else leaves it.
    Component {
        id: keyWatch
        Connections {
            function onPressed(event) { kit.focusVisible = true; }
        }
    }
    function watchKeys(window) {
        keyWatch.createObject(kit, { target: window.contentItem.Keys });
    }

    // A motion token by name: the app's tokens, else the kit's own where they predate it (a shell not yet regenerated).
    function motion(name) {
        return kit.tokens.motion[name] ?? kit.fallback.motion[name];
    }

    // A name Tacit draws. The lint refuses others: installs carry no other symbol font.
    function hasSymbol(name) {
        return Names.names[name] === 1;
    }
}
