# Tacit Kit

The parts Tacit's own apps are made of, for anyone making an app for Tacit: lists, the rail, page headers, search,
menus, buttons, panels, fields, switches, sliders, tabs, players and the states between them. One QML module,
`Tacit.Kit`, for [Quickshell](https://quickshell.org) apps. The guide to using it well is at
[design.tacitos.co](https://design.tacitos.co); a whole app made only of these parts is
the [Music example](https://github.com/ciscobugger/tacit-music-example), a starting point to build on.

## Use it

On Tacit the kit is installed (`tacit-kit`, in `/usr/lib/qt6/qml/Tacit/Kit`). Elsewhere, put `qml/` on the import path:
`QML_IMPORT_PATH=/path/to/tacit-kit/qml qs -p your-app.qml`.

```qml
import QtQuick
import Quickshell
import Tacit.Kit

FloatingWindow {
    color: "transparent"
    WindowGround {}
    RowList {
        id: list
        anchors.fill: parent
        model: ["Undertow.mp3", "Lease.pdf"]
        delegate: ListRow {
            required property string modelData
            required property int index
            width: list.rowWidth
            focusable: false                       // the list is the one tab stop
            glyph: "description"; name: modelData
            selected: list.isSelected(index); ring: list.ringAt(index)
            onClicked: m => list.clickAt(index, m)
        }
    }
}
```

The parts read their colours, sizes, spaces, corners and motion from `Kit.tokens`. On Tacit those follow the user's
wallpaper by themselves, the way the desktop's do (`Live.qml` reads the palette Tacit generates for each wallpaper);
without it they fall back to one fixed palette (`Defaults.qml`). Use the tokens for your own drawing too: an app that
does looks like it belongs on every wallpaper.

`QtQuick.Controls` has a `Menu`, a `Slider` and a `Switch` too. In a file that imports both, import the kit under a
name: `import Tacit.Kit as K`, then `K.Slider`.

## What is here

- `qml/Tacit/Kit/`: the parts. Each file's first comment is its spec: what it is for, its states, its keys.
- `tokens/tokens.json`: the one source of every value (colour roles as recipes over the wallpaper's palette, the five
  text inks by contrast, sizes, spaces, corners, motion). `tools/generate.py` turns it into `Live.qml`, `Defaults.qml`,
  CSS for the web and the tables in the docs.
- `catalogue/`: every part in its states on two palettes (`tools/catalogue.sh` renders them).
- `docs/agents.md`: the rules and commands for a coding agent building a Tacit app. Copy it into your app's repo as
  `AGENTS.md`, or point the agent at https://design.tacitos.co/agents.md.
- `tools/grab.sh`: runs an app with no desktop and saves what its window draws on each palette in `tools/palettes/`.
- `tools/lint.py`: checks an app for raw colours, literal sizes and corners, faded text and symbols Tacit does not
  draw.

## Requirements

Quickshell 0.3 or later on Qt 6.7 or later. The type (Tacit Sans, Tacit Sans Display, Tacit Code) and the symbols
are in `qml/Tacit/Kit/fonts/` and the module loads them, so nothing has to be installed.

## Licence

- The kit's code: LGPL-3.0-or-later (`LICENSE`, which builds on `COPYING.GPL-3`). Use the kit in apps under any
  licence; changes to the kit itself stay open.
- Its fonts (`qml/Tacit/Kit/fonts/`): SIL Open Font License 1.1 (the `OFL-*.txt` beside them, and `FONTLOG.md`),
  with "Tacit" as a Reserved Font Name.
- The documentation at design.tacitos.co, with its figures and the pictures in `docs/assets/`: CC BY 4.0.
- The name: see `TRADEMARKS.md`.
