// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// The ground an app window draws (Files, Music, Praxis and Settings each drew this by hand): the shell's ground at
// the user's see-through setting, so the wallpaper shows through as much as everywhere else (`windowGround` at
// `1 - windowSeeThrough` opacity; both follow the wallpaper and the setting by themselves). Corners are the window's
// (18). Put it first in the window's root so everything else draws over it; it fills its parent. Where the
// compositor rounds the window itself, set `radius: 0`. The blur behind it is the compositor's, not this part's.
Rectangle {
    anchors.fill: parent
    radius: Kit.tokens.radius.window
    color: Qt.alpha(Kit.tokens.windowGround, 1 - Kit.tokens.windowSeeThrough)
}
