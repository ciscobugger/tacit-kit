"""Tacit's colour maths, as the shell does it in QML, so values resolved here equal the desktop's.

QColor keeps each channel as 16 bits and Qt.rgba() takes floats, so every mix is rounded to 1/65535 in single
precision (QColor::fromRgbF). Text colours come from Appearance.inkFor (an APCA Lc reached along the palette's hue)
and Tacit.quieter; ColorUtils.mix, transparentize and apcaLc are ported line for line.
"""
import numpy as np

F = np.float32
U16 = F(65535.0)


def _q(v):
    """A float channel as QColor stores it: float32 times 65535, rounded half up, back to a float."""
    x = F(v) * U16
    return int(np.floor(x + F(0.5))) / 65535.0


class C:
    """A colour as QColor holds it: 16-bit channels, read back as floats (QColor::redF and so on)."""

    __slots__ = ("r", "g", "b", "a")

    def __init__(self, r, g, b, a=1.0):
        self.r, self.g, self.b, self.a = _q(r), _q(g), _q(b), _q(a)

    @staticmethod
    def hex(s):
        s = s.lstrip("#")
        a = 1.0
        if len(s) == 8:          # #aarrggbb, as Qt reads it
            a, s = int(s[:2], 16) / 255.0, s[2:]
        r, g, b = (int(s[i:i + 2], 16) / 255.0 for i in (0, 2, 4))
        return C(r, g, b, a)

    def hsl_lightness(self):
        return (max(self.r, self.g, self.b) + min(self.r, self.g, self.b)) / 2

    def to_hex(self):
        """8-bit, as the colour reaches the screen (QColor::red() is the 16-bit value / 257, rounded)."""
        q = lambda v: int(round(round(v * 65535) / 257))
        h = "#%02x%02x%02x" % (q(self.r), q(self.g), q(self.b))
        return h if self.a >= 1 else "#%02x%s" % (q(self.a), h[1:])

    def u16(self):
        return tuple(round(v * 65535) for v in (self.r, self.g, self.b, self.a))


def qt_color(c):
    """Qt.color() on a colour goes through its name, so each channel is rounded to 8 bits (the shell's ColorUtils
    passes every input through it)."""
    q = lambda v: round(round(v * 65535) / 257) / 255.0
    a = 1.0 if round(c.a * 65535) == 65535 else q(c.a)
    return C(q(c.r), q(c.g), q(c.b), a)


def mix(c1, c2, p=0.5):
    c1, c2 = qt_color(c1), qt_color(c2)
    return C(p * c1.r + (1 - p) * c2.r, p * c1.g + (1 - p) * c2.g, p * c1.b + (1 - p) * c2.b, p * c1.a + (1 - p) * c2.a)


def transparentize(c, p=1.0):
    c = qt_color(c)
    return C(c.r, c.g, c.b, c.a * (1 - p))


def apca_lc(text, ground):
    def y(q):
        v = 0.2126729 * q.r ** 2.4 + 0.7151522 * q.g ** 2.4 + 0.0721750 * q.b ** 2.4
        return v if v > 0.022 else v + (0.022 - v) ** 1.414
    yt, yb = y(qt_color(text)), y(qt_color(ground))
    if yb > yt:
        s = (yb ** 0.56 - yt ** 0.57) * 1.14
        return 0 if s < 0.1 else (s - 0.027) * 100
    s = (yb ** 0.65 - yt ** 0.62) * 1.14
    return 0 if s > -0.1 else (s + 0.027) * 100


def ink_for(lc, ground, on_background):
    """Appearance.inkFor: the first point on ground -> onBackground -> white (or black) that reaches Lc."""
    far = C(1, 1, 1) if ground.hsl_lightness() < 0.5 else C(0, 0, 0)
    at = lambda t: mix(on_background, ground, t) if t <= 1 else mix(far, on_background, t - 1)
    lo, hi = 0.0, 2.0
    for _ in range(18):
        mid = (lo + hi) / 2
        if abs(apca_lc(at(mid), ground)) < lc:
            lo = mid
        else:
            hi = mid
    return at(hi)


def quieter(fg, bg, lc):
    """Tacit.quieter: fg toward bg as far as it keeps Lc on bg."""
    lo, hi = 0.0, 1.0
    for _ in range(16):
        mid = (lo + hi) / 2
        if abs(apca_lc(mix(fg, bg, mid), bg)) >= lc:
            hi = mid
        else:
            lo = mid
    return mix(fg, bg, hi)
