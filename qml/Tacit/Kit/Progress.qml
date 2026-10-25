// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// How far a long job has come (copying files, an update downloading): the notch's bar, 4 px, the track in the past ink
// and the reached part in the accent. When the end is not known, `going` sends an accent stretch along it, as the page header
// does while it reads (still, at the bar's start, when `Kit.reducedMotion` is on). Say what the job is in words beside it; the bar never stands alone.
// A screen reader reads `value` against `minimumValue` and `maximumValue` (0 and 1); while `going` it hears an activity
// indicator "in progress" with no value (it would say 0 %).
Item {
    id: bar
    property real value: 0              // 0 to 1
    property bool going: false          // the end is not known
    property string label
    readonly property real minimumValue: 0
    readonly property real maximumValue: 1

    implicitWidth: 240
    implicitHeight: 4
    clip: true
    // with no known end it has no value to read: it is an activity indicator, described as in progress
    Accessible.role: going ? Accessible.Indicator : Accessible.ProgressBar
    Accessible.description: going ? "In progress" : ""
    Accessible.name: label

    Rectangle { anchors.fill: parent; radius: height / 2; color: Kit.tokens.past }
    Rectangle {
        visible: !bar.going
        width: Math.max(bar.height, bar.width * bar.value)
        height: bar.height; radius: height / 2
        color: Kit.tokens.accent
        Behavior on width { NumberAnimation { duration: Kit.ms(Kit.tokens.motion.arriveSmall.ms); easing.type: Easing.BezierSpline; easing.bezierCurve: Kit.tokens.motion.arriveSmall.curve } }
    }
    Rectangle {
        id: stretch
        visible: bar.going
        width: Math.min(220, bar.width / 3); height: bar.height; radius: height / 2
        color: Kit.tokens.accent
        NumberAnimation on x {
            running: bar.going && !Kit.reducedMotion
            loops: Animation.Infinite
            from: -stretch.width; to: bar.width
            duration: Kit.motion("sweep").ms
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Kit.motion("sweep").curve
        }
    }
}
