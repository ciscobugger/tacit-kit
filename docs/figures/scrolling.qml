// Scrolling (Glide): in use, the two motions as curves, and a do and a don't about following the fingers.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["curves", 760, 300], ["do-follows", 418, 220], ["dont-lags", 418, 220]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }

    // Qt's bezierCurve [0, 0, 0, 1, 1, 1]: control points (0,0) and (0,1), end (1,1); y at x by bisection
    function bez(x, p) {
        let lo = 0, hi = 1;
        for (let i = 0; i < 40; i++) { const t = (lo + hi) / 2; const bx = 3 * (1 - t) * (1 - t) * t * p[0] + 3 * (1 - t) * t * t * p[2] + t * t * t; if (bx < x) lo = t; else hi = t; }
        const t = (lo + hi) / 2;
        return 3 * (1 - t) * (1 - t) * t * p[1] + 3 * (1 - t) * t * t * p[3] + t * t * t;
    }
    // after a flick at v0 px/ms: distance(t) = v0 (1 - 0.998^t) / -ln 0.998, it stops when the speed is under 0.02
    readonly property real glideMs: Math.log(100) / -Math.log(0.998)
    function glide(u) { return (1 - Math.pow(0.998, u * app.glideMs)) / (1 - Math.pow(0.998, app.glideMs)); }

    DocWindow {
        visible: app.fig === "hero"
        anchors.fill: parent
        wx: 64; wy: 40; wallX: -400; wallY: -600
        PageHeader { width: 704; canGoBack: true; crumbs: ["Home"]; here: "Downloads" }
        Column { x: 12; y: 78; width: 660
            ListRow { width: parent.width; glyph: "picture_as_pdf"; name: "Lease agreement.pdf"; facts: ["2.2 MB", "14:40"] }
            ListRow { width: parent.width; glyph: "description"; name: "Budget 2027.xlsx"; facts: ["84 kB", "09:12"]; selected: true }
            ListRow { width: parent.width; glyph: "music_note"; name: "Undertow - Mara Velde.mp3"; facts: ["11.6 MB", "18:02"] }
            ListRow { width: parent.width; glyph: "deployed_code"; name: "photos-october.zip"; facts: ["420 MB", "08:31"] }
        }
    }

    F { n: "curves"
        Item { x: 41; y: 40; width: 330; height: 220
            TacitText { text: "Mouse wheel, one notch"; weight: "medium" }
            DocCurve { y: 36; width: 330; height: 184; tEnd: "200 ms"; fn: u => app.bez(u, [0, 0, 0, 1]) }
        }
        Item { x: 399; y: 40; width: 330; height: 220
            TacitText { text: "Touchpad, after a flick"; weight: "medium" }
            DocCurve { y: 36; width: 330; height: 184; tEnd: "2.3 s"; fn: u => app.glide(u) }
        }
    }

    F { n: "do-follows"
        DocCentre { cw: 340; ch: 166
            Item { x: 6; y: -3; width: 340; height: 150
                TacitText { text: "Position over time"; ink: "sec" }
                DocCurve { y: 28; width: 340; height: 100; tEnd: "Time"; fn: u => 0.1 + 0.8 * u * u; fn2: u => 0.1 + 0.8 * u * u }
                Row { y: 150; spacing: 18
                    Row { spacing: 8; Rectangle { width: 22; height: 9; radius: 4; anchors.verticalCenter: parent.verticalCenter; color: Qt.alpha(Kit.tokens.inkMain, 0.28) } TacitText { text: "Fingers"; ink: "sec" } }
                    Row { spacing: 8; Rectangle { width: 22; height: 3; radius: 1.5; anchors.verticalCenter: parent.verticalCenter; color: Kit.tokens.accent } TacitText { text: "Content"; ink: "sec" } }
                }
            }
        }
    }
    F { n: "dont-lags"
        DocCentre { cw: 340; ch: 166
            Item { x: 6; y: -3; width: 340; height: 150
                TacitText { text: "Position over time"; ink: "sec" }
                DocCurve { y: 28; width: 340; height: 100; tEnd: "Time"; fn: u => 0.1 + 0.8 * Math.max(0, u - 0.3) * Math.max(0, u - 0.3) / 0.49; fn2: u => 0.1 + 0.8 * u * u }
                Row { y: 150; spacing: 18
                    Row { spacing: 8; Rectangle { width: 22; height: 9; radius: 4; anchors.verticalCenter: parent.verticalCenter; color: Qt.alpha(Kit.tokens.inkMain, 0.28) } TacitText { text: "Fingers"; ink: "sec" } }
                    Row { spacing: 8; Rectangle { width: 22; height: 3; radius: 1.5; anchors.verticalCenter: parent.verticalCenter; color: Kit.tokens.accent } TacitText { text: "Content"; ink: "sec" } }
                }
            }
        }
    }
}
