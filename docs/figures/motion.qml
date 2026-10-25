// Motion: each scheme's curve drawn from the token, with its time.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["curves", 760, 400]]
    readonly property var t: Kit.tokens
    Item { visible: app.fig === "curves"; anchors.fill: parent
        DocGlass { anchors.fill: parent }
        Grid { x: 24; y: 34; columns: 3; columnSpacing: 20; rowSpacing: 24
            Repeater {
                model: [["Arrive", "arrive"], ["Leave", "leave"], ["Fade", "fade"], ["Fade, fast", "fadeFast"], ["Hover", "hover"], ["Spring", "spring"]]
                Item {
                    id: cell
                    required property var modelData
                    readonly property var m: app.t.motion[modelData[1]]
                    width: 224; height: 158
                    DocCurve {
                        width: 224; height: 128
                        tEnd: cell.m.ms + " ms"
                        fn: {
                            const p = cell.m.curve;
                            if (!(Array.isArray(p) && p.length >= 4)) return u => u;
                            // Qt's bezierCurve: control points (p0,p1), (p2,p3), then the end point (1,1); y at x by bisection
                            return x => { let lo = 0, hi = 1;
                                for (let i = 0; i < 40; i++) { const s = (lo + hi) / 2; const bx = 3 * (1 - s) * (1 - s) * s * p[0] + 3 * (1 - s) * s * s * p[2] + s * s * s; if (bx < x) lo = s; else hi = s; }
                                const s = (lo + hi) / 2;
                                return 3 * (1 - s) * (1 - s) * s * p[1] + 3 * (1 - s) * s * s * p[3] + s * s * s; };
                        }
                    }
                    TacitText { y: 134; text: cell.modelData[0]; weight: "medium" }
                }
            }
        }
    }
}
