# Docs figures

The figures of the Tacit Design pages (design.tacitos.co) are QML files in `figures/`, one per page. Each draws its
pictures with the kit itself and saves them as PNG.

## Render a page

```
sh docs/render.sh list-row /tmp/figs
```

This writes `/tmp/figs/dusk/<figure>.png` and `/tmp/figs/moss/<figure>.png` at twice the size (`tools/figures.sh` is the
same script under its older name). It runs offscreen, in a private directory per palette, with the palette from
`tools/palettes/` and the wallpapers and pictures from `docs/assets/`. Nothing else on the machine is read.

Needs Quickshell 0.3+ (Qt 6.7+) and a Qt with the offscreen platform and OpenGL. ImageMagick is used by `build.py figs`
in the site repo (tacit-site), which renders every page and converts the PNGs to WebP for the pages.

## Assets

`assets/` holds the two wallpapers (`wall-dusk.jpg`, `wall-moss.jpg`, each with a `-blur` twin) and the covers (`c*.jpg`)
and pictures (`p*.jpg`) the figures show. A figure reads the folder from `FIGURE_ASSETS`, which `render.sh` sets.

## Pictures composed from the apps

The Files and Music pages show the apps' own renders, laid on the wallpaper. These need the apps and the shell, so they
are not part of `render.sh`:

- Files: `tools/files-run.sh` runs Files in a hidden Weston; the result is in `figures/files-src/`. `files-run.sh` and
  `tools/catalogue.sh` still read the mock tree in `TACIT_MOCKS` (default `~/.cache/tacit-mocks`).
- Music: `figures/music-figures.py` cuts the Music app's grabs into the page's figures; its wallpaper argument is `docs/assets`.
