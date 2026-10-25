// The docs' one chart: a curve of position (0 to 100 %) over time, on axes. Two hairline axes meet at the origin, a
// dotted line marks 100 %, ticks mark 0 and 100 % up the side and 0 and `tEnd` along the bottom. `fn` maps time 0..1 to
// position 0..1; `fn2`, when set, is drawn first as a wide faint line (the fingers, in the scrolling guideline).
import QtQuick
import Tacit.Kit

Item {
    id: cv
    property var fn: u => u
    property var fn2: null
    property string tEnd: ""
    property color col: Kit.tokens.accent
    property color col2: Qt.alpha(Kit.tokens.inkMain, 0.28)
    // the plot area, inside the room the labels take: 38 on the left, 22 below
    readonly property real px: 38
    readonly property real pw: width - px - 10
    readonly property real ph: height - 22 - 8
    readonly property real py: 8

    Canvas {
        anchors.fill: parent
        onPaint: {
            const c = getContext("2d"); c.reset();
            const ax = String(Qt.alpha(Kit.tokens.inkMain, 0.30)), grid = String(Qt.alpha(Kit.tokens.inkMain, 0.14));
            const X = u => cv.px + 6 + u * (cv.pw - 12), Y = v => cv.py + cv.ph - 6 - v * (cv.ph - 12);
            c.lineWidth = 1;
            c.strokeStyle = grid; c.setLineDash([2, 3]);
            c.beginPath(); c.moveTo(cv.px, Y(1) + 0.5); c.lineTo(cv.px + cv.pw, Y(1) + 0.5); c.moveTo(X(1) + 0.5, cv.py); c.lineTo(X(1) + 0.5, cv.py + cv.ph); c.stroke();
            c.setLineDash([]); c.strokeStyle = ax;
            c.beginPath(); c.moveTo(cv.px + 0.5, cv.py); c.lineTo(cv.px + 0.5, cv.py + cv.ph + 0.5); c.lineTo(cv.px + cv.pw, cv.py + cv.ph + 0.5); c.stroke();
            // ticks: 0 and 100 % up the side, 0 and the end along the bottom
            c.beginPath();
            c.moveTo(cv.px - 4, Y(0) + 0.5); c.lineTo(cv.px, Y(0) + 0.5); c.moveTo(cv.px - 4, Y(1) + 0.5); c.lineTo(cv.px, Y(1) + 0.5);
            c.moveTo(X(0) + 0.5, cv.py + cv.ph); c.lineTo(X(0) + 0.5, cv.py + cv.ph + 4); c.moveTo(X(1) + 0.5, cv.py + cv.ph); c.lineTo(X(1) + 0.5, cv.py + cv.ph + 4);
            c.stroke();
            const line = (f, color, lw) => {
                c.strokeStyle = String(color); c.lineWidth = lw; c.lineCap = "round"; c.lineJoin = "round"; c.beginPath();
                for (let i = 0; i <= 120; i++) { const u = i / 120; if (i === 0) c.moveTo(X(u), Y(f(u))); else c.lineTo(X(u), Y(f(u))); }
                c.stroke();
            };
            if (cv.fn2) line(cv.fn2, cv.col2, 9);
            line(cv.fn, cv.col, 3);
        }
        Component.onCompleted: requestPaint()
    }
    TacitText { text: "100 %"; size: "meta"; cut: "numbers"; ink: "meta"; x: cv.px - 8 - width; y: cv.py + 6 - height / 2 + 1 }
    TacitText { text: "0"; size: "meta"; cut: "numbers"; ink: "meta"; x: cv.px - 8 - width; y: cv.py + cv.ph - 6 - height / 2 }
    TacitText { text: "0"; size: "meta"; cut: "numbers"; ink: "meta"; x: cv.px + 6 - width / 2; y: cv.py + cv.ph + 7 }
    TacitText { visible: cv.tEnd !== ""; text: cv.tEnd; size: "meta"; cut: "numbers"; ink: "meta"; x: cv.px + cv.pw - 6 - width / 2; y: cv.py + cv.ph + 7 }
}
