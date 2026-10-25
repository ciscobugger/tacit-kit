// Accessibility: hit areas drawn around small controls, and the keyboard ring on each kind of part.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hit-areas", 760, 200], ["focus", 760, 200]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    component Area: Rectangle { color: Qt.alpha(Kit.tokens.accent, 0.12); border.width: 1; border.color: Qt.alpha(Kit.tokens.accent, 0.8); radius: 4 }

    F { n: "hit-areas"
      DocCentre { cw: 700; ch: 76
        Item { x: 0; y: 0
            IconButton { symbol: "star"; label: "Star" }
            Area { width: 36; height: 36; z: 1; radius: 18; color: "transparent" }
            TacitText { x: -4; y: 56; text: "Icon button: 36 by 36"; ink: "sec" }
        }
        Item { x: 240; y: 0
            Area { x: -12; width: 200; height: 40 }
            WordAction { text: "Open with…"; width: 176 }
            TacitText { x: -12; y: 56; text: "Action: 40 high, the whole line"; ink: "sec" }
        }
        Item { x: 500; y: 0
            Area { x: 0; width: 180; height: 44 }
            ListRow { width: 180; glyph: "description"; name: "Name"; facts: [] }
            TacitText { y: 56; text: "Row: 44 high, the whole row"; ink: "sec" }
        }
      }
    }
    F { n: "focus"
      DocCentre {
        Column { spacing: 18
            Row { spacing: 28
                IconButton { symbol: "star"; label: "Star"; previewState: "focus" }
                Slab { text: "Open"; tone: "default"; previewState: "focus" }
                WordAction { text: "Open with…"; width: 150; previewState: "focus" }
                Tabs { labels: ["Replace", "Number"]; current: 0; previewState: "focus" }
            }
            Row { spacing: 28
                ListRow { width: 300; glyph: "description"; name: "Name"; facts: ["Fact"]; factWidths: [64]; previewState: "focus"; selected: true }
                Field { width: 240; text: "Holiday "; hint: "Replace with"; previewState: "focus" }
            }
            TacitText { text: "A 2-pixel ring in the accent, 2 pixels outside the part, at the first key press."; ink: "sec" }
        }
      }
    }
}
