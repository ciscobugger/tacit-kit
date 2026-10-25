# Building a Tacit app: notes for coding agents

Copy this file into your app's repository as `AGENTS.md` (or point your agent at
https://design.tacitos.co/agents.md). It tells an AI agent how to build an app that looks and behaves like Tacit's own
apps, with Tacit.Kit. The full guide, with a page for every part, is https://design.tacitos.co.

## What a Tacit app is

A QML app for [Quickshell](https://quickshell.org) (0.3 or later, Qt 6.7 or later) made of Tacit.Kit's parts. On Tacit
the kit is installed; elsewhere, put the kit's `qml/` folder on the import path.

```qml
import QtQuick
import Quickshell
import Tacit.Kit

FloatingWindow {
    id: window
    color: "transparent"
    Component.onCompleted: Kit.watchKeys(window)   // the focus ring shows once a key is pressed
    WindowGround {}                                 // the window's see-through ground; nothing else draws one
    // the app's parts go here
}
```

Run it: `qs -p app.qml` on Tacit, `QML_IMPORT_PATH=/path/to/tacit-kit/qml qs -p app.qml` elsewhere. If a file that
imports `Tacit.Kit` also imports `QtQuick.Controls`, import the kit under a name (`import Tacit.Kit as K`, then
`K.Slider`), because Controls has parts with the same names.

## Check your work

- `python3 /path/to/tacit-kit/tools/lint.py <your app folder>` finds raw colours, literal font sizes and corners,
  text faded with opacity, and symbol names Tacit does not draw. It exits 1 when it finds anything. Fix every finding.
- `/path/to/tacit-kit/tools/grab.sh app.qml shots/` runs the app with no desktop and saves `shots/dusk.png` and
  `shots/moss.png`. Look at both: Tacit's colours come from the wallpaper, and an app must work on every one.
- The Music example (https://github.com/ciscobugger/tacit-music-example) is a whole app made only of kit parts. When
  unsure how to put parts together, read how it does it.

## Choose the part by the job

| Job | Use | Not |
|---|---|---|
| Show a list of things | `RowList` of `ListRow`; `PictureGrid` for pictures; `CoverGrid` for covers with words | Buttons or tabs standing in for a list |
| Choose one of a few | `Choices` up to six; `Select` for more; `Tabs` for views of one thing | A switch, a check, a menu of two |
| Choose several | `Check`; a `Menu` whose lines stay open; a list with several rows selected | `Choices`, which is one only |
| Act on the page | `Slab` for one or two actions; `WordAction`s for a list of them | An `InlineLink`, a `Switch` |
| Act on one item | the item's `Menu`; the actions in a `DockedPanel` | A button on every row |
| Something risky | do it and offer Undo in a `Notice`; for what cannot be undone, `confirm` on the `Slab` or `WordAction` | A dialog that asks |
| Say what just happened | `Notice`; `PageState`; `Progress` | A tooltip, or a box that must be closed |
| Enter text | `Field` for a line; `TextArea` for several; `SearchField` for the page | A field for a choice of a few |
| Pick a value | `Switch` on or off; `Slider` for an amount; `Select` from a list | A slider for a choice of three |
| Move between places | `Rail`; `PageHeader`; `Tabs`; `InlineLink`; `JumpIndex` | A menu as navigation |
| Filter and order | `ViewBar`; the `SearchField` | A filter built into the list itself |

Each part's first comment in `qml/Tacit/Kit/<Part>.qml` is its spec: what it is for, its properties, keys and states.
Read it before using the part. The design guide has a page per part with the same, plus figures.

## Rules

1. **Values come from `Kit.tokens`.** Colours (`inkMain`, `inkSec`, `inkMeta`, `inkFaint`, `accent`, `risk`,
   `windowGround`, ...), type sizes (`size.row`, `size.body`, `size.section`, ...), spaces (`space.s`, `space.m`,
   `space.l`, ...), corners (`radius.row`, `radius.slab`, `radius.window`, ...). Never write a colour, a pixel size or a
   corner by hand: the palette follows the wallpaper and the values change with it.
2. **Text is quieter by ink, never by opacity.** Use `TacitText` with `ink: "sec"`, `"meta"` or `"faint"`. Don't set
   `opacity` on text.
3. **The accent is a mark, never text.** It shows the current place, the way forward, the focus ring, what is playing.
4. **No dialogs.** An app asks where the person already is. A name is edited in its row (`ListRow`'s `editing`; F2
   starts it through `RowList`'s `editRequested`). What can be undone is done at once, and a `Notice` offers Undo. Only
   what cannot be undone asks first, and the action itself asks (`confirm` on a `Slab` or `WordAction`). The kit has no
   dialog part on purpose; don't build one.
5. **One window ground, no extra surfaces.** `WindowGround` is the app's ground. Don't draw grey cards or panels inside
   the content, and no shadows. A side panel is a `DockedPanel`.
6. **Symbols are Tacit's own.** Use `Symbol { text: "folder" }` or a part's `glyph: "folder"` with names Tacit draws
   (the list is `qml/Tacit/Kit/symbols.js`; `Kit.hasSymbol(name)` checks one). The lint reports any other; a name Tacit
   does not draw shows nothing.
7. **Every pointer action has a key.** Lists are one Tab stop and own their arrows (`RowList`); Enter or a double click
   opens (`activated`), Space peeks (`peeked`), Escape closes what is open. Give each list and grid its `label` so a
   screen reader can name it.
8. **Motion uses the kit's tokens:** `duration: Kit.ms(Kit.motion("press").ms)`. `Kit.ms()` returns 0 when the person
   has turned motion off (`Kit.reducedMotion`), so every animation stops with it.
9. **Signals use one word per meaning:** `activated` does the thing (buttons, rows, links, Undo), `picked` chooses one of
   a set (menus, tabs, choices), `toggled` turns something on or off.
10. **Words are plain.** Sentence case. Name what an action does ("Rename", "Move to the trash"), never "OK". Say where a
    search looks ("Search Downloads"). No exclamation marks, no jargon a person did not ask for.
11. **Tacit is dark only.** Check the app on more than one wallpaper (the grab tool does dusk and Moss).

## When a part is missing

Don't hand-draw a look-alike. Build from kit parts and `Kit.tokens`, keep the rules above, and say in your answer which
part you wished the kit had. Report it at https://github.com/ciscobugger/tacit-kit/issues.
