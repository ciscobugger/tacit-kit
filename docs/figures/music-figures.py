#!/usr/bin/env python3
"""Tacit Design: figures of the Music page and the opening figure of the front page, cut from renders.

    music-figures.py <music 2x grabs> <wallpapers> <out> <hero windows>

Music 2x grabs: raw-<palette>-<scene>.png, transparent window grabs at QT_SCALE_FACTOR=2 (scenes albums, album, artist,
recent, playing, half (760 wide), artists (1000 x 600), search, cantplay, empty; tacit-music-example tools/render.sh's
raw step with QT_SCALE_FACTOR=2). Each is laid on the blurred wallpaper 40 px in (80 at 2x) and cut; boxes below are in
the window's 1x coordinates plus that margin, doubled when cut. The parts figure carries callouts drawn as the kit's
DocCallout draws them. Wallpapers: wall-dusk.jpg, wall-moss.jpg and their -blur twins (1600 x 1000). Hero windows:
transparent grabs files-<palette>.png (Files at 1440 x 314) and music-<palette>.png (Albums at 1520 x 920).
Writes <out>/music/<figure>-<palette>.png and <out>/index/hero-<palette>.png.
"""
import os
import sys
from PIL import Image, ImageChops, ImageDraw, ImageFont

grabs, walls, out, raws = sys.argv[1:5]
FONT = os.path.expanduser("~/.local/share/fonts/tacit/TacitSans[wght].ttf")
PAL = [("dusk", "wall-dusk.jpg"), ("moss", "wall-moss.jpg")]
INKS = {"dusk": ("#d9d3d1", "#e6e0de", "#ede8e6"), "moss": ("#d5d5c9", "#e2e2d6", "#eaeae0")}  # meta, sec, main

# figure: (scene, crop box in 1x canvas coordinates, or None for the whole window on the wallpaper)
CROPS = {
    "hero": ("albums", (0, 0, 1000, 640)),
    "parts": ("album", (0, 0, 1000, 640)),
    "artist": ("artist", (340, 0, 1340, 640)),
    "recent": ("recent", (340, 0, 1340, 640)),
    "artists": ("artists", None),
    "playing": ("playing", (340, 0, 1340, 680)),
    "bar": ("album", (340, 780, 1340, 1000)),
    "search": ("search", (380, 0, 1600, 560)),
    "empty": ("empty", (340, 0, 1340, 560)),
    "cantplay": ("cantplay", (340, 400, 1340, 1000)),
    "half": ("half", None),
}
# the parts figure's callouts: n, ring centre, side the leader leaves from, the piece's box (1x canvas coordinates)
CALLOUTS = [
    (1, (20, 193), "right", (46, 50, 334, 336)),     # rail
    (2, (559, 20), "down", (445, 58, 673, 94)),      # page header
    (3, (364, 257), "right", (388, 137, 628, 377)),  # cover
    (4, (950, 200), "left", (657, 145, 869, 255)),   # title block
    (5, (950, 357), "left", (657, 334, 865, 380)),   # Play and Shuffle
    (6, (950, 470), "left", (420, 404, 903, 700)),   # song rows (runs off the figure)
]


def compose(pal, scene):
    win = Image.open(os.path.join(grabs, "raw-%s-%s.png" % (pal, scene))).convert("RGBA")
    wall = "wall-dusk-blur.jpg" if pal == "dusk" else "wall-moss-blur.jpg"
    canvas = Image.open(os.path.join(walls, wall)).convert("RGBA").resize((win.width + 160, win.height + 160))
    canvas.alpha_composite(win, (80, 80))
    return canvas.convert("RGB")


def dashed(d, a, b, ink, k=2):
    (x0, y0), (x1, y1) = a, b
    n = int(max(abs(x1 - x0), abs(y1 - y0)) // (2 * k))
    for i in range(n + 1):
        t0, t1 = i * 2 * k, i * 2 * k + k
        L = max(abs(x1 - x0), abs(y1 - y0)) or 1
        if t0 >= L:
            break
        t1 = min(t1, L)
        d.line((x0 + (x1 - x0) * t0 / L, y0 + (y1 - y0) * t0 / L, x0 + (x1 - x0) * t1 / L, y0 + (y1 - y0) * t1 / L), fill=ink, width=k)


def callouts(img, pal, ox, oy):
    """DocCallout at 2x: a ring with its number centred by ink, a dotted leader, a dotted box 3 px out."""
    meta, sec, main = INKS[pal]
    d = ImageDraw.Draw(img)
    f = ImageFont.truetype(FONT, 26)
    f.set_variation_by_axes([500])
    X = lambda v: (v - ox) * 2
    Y = lambda v: (v - oy) * 2
    for n, (cx, cy), side, (bx0, by0, bx1, by1) in CALLOUTS:
        bx0, by0, bx1, by1 = bx0 - 3, by0 - 3, bx1 + 3, by1 + 3
        for a, b in (((bx0, by0), (bx1, by0)), ((bx1, by0), (bx1, by1)), ((bx1, by1), (bx0, by1)), ((bx0, by1), (bx0, by0))):
            dashed(d, (X(a[0]), Y(a[1])), (X(b[0]), Y(b[1])), meta)
        if side == "right":
            dashed(d, (X(cx + 11), Y(cy)), (X(bx0), Y(cy)), meta)
        elif side == "left":
            dashed(d, (X(cx - 11), Y(cy)), (X(bx1), Y(cy)), meta)
        else:
            dashed(d, (X(cx), Y(cy + 11)), (X(cx), Y(by0)), meta)
        d.ellipse((X(cx - 11), Y(cy - 11), X(cx + 11), Y(cy + 11)), outline=sec, width=2)
        d.text((X(cx), Y(cy) + 0.354 * 26), str(n), font=f, fill=main, anchor="ms")


def corner_mask(size, corners, radius=18):
    m = Image.new("L", (size[0] * 4, size[1] * 4), 0)
    ImageDraw.Draw(m).rounded_rectangle((0, 0, m.width - 1, m.height - 1), radius * 4, fill=255, corners=corners)
    return m.resize(size, Image.LANCZOS)


def hero(pal, wall):
    """Files above, Music below, tiled as the desktop tiles them (8 px apart): Files is rendered at its tiled height,
    so its foot is its own; both run off the right edge, Music off the bottom. Each window is a transparent grab laid
    on the blurred wallpaper where it stands, so its glass shows what is behind it there."""
    W, H, gap, x = 1000, 800, 8, 40
    canvas = Image.open(os.path.join(walls, wall)).convert("RGBA").crop((0, 0, W, H))
    blur = Image.open(os.path.join(walls, wall.replace(".jpg", "-blur.jpg"))).convert("RGBA").crop((0, 0, W, H))
    f = Image.open(os.path.join(raws, "files-%s.png" % pal)).convert("RGBA")
    places = [(f, 40, (True, False, False, True)),
              (Image.open(os.path.join(raws, "music-%s.png" % pal)).convert("RGBA"), 40 + f.height + gap,
               (True, False, False, False))]
    for win, y, corners in places:
        win = win.crop((0, 0, min(win.width, W - x), min(win.height, H - y)))
        glass = blur.crop((x, y, x + win.width, y + win.height))
        glass.alpha_composite(win)
        shape = ImageChops.multiply(corner_mask(win.size, corners), win.getchannel("A").point(lambda a: 255 if a else 0))
        canvas.paste(glass, (x, y), shape)
    return canvas.convert("RGB")


os.makedirs(os.path.join(out, "music"), exist_ok=True)
os.makedirs(os.path.join(out, "index"), exist_ok=True)
for pal, wall in PAL:
    for name, (scene, box) in CROPS.items():
        canvas = compose(pal, scene)
        im = canvas if box is None else canvas.crop(tuple(v * 2 for v in box))
        if name == "parts":
            callouts(im, pal, box[0], box[1])
        im.save(os.path.join(out, "music", "%s-%s.png" % (name, pal)))
    hero(pal, wall).save(os.path.join(out, "index", "hero-%s.png" % pal))
