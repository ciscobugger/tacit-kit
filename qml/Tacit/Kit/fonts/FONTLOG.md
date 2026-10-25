# Tacit type family

Tacit Sans, Tacit Mono and Tacit Code are the typefaces of Tacit, made by the Tacit Project in 2026.
They are released under the SIL Open Font License 1.1, like the fonts they are made from.

| Font | Made from | Their authors |
|---|---|---|
| Tacit Sans | Onest (lowercase, figures, signs); Readex Pro (capitals) | Dmitri Voloshin, Andrey Kudryavtsev; Bonnie Shaver-Troup, Thomas Jockin |
| Tacit Mono, Tacit Code | Google Sans Code | The Google Sans Code Authors |

What Tacit changed is listed in README.md. "Google Sans" is a trademark of Google and "RevReading Lexend" is a
Reserved Font Name; neither is used in these fonts' names.

1.000 (2026-10-01): first version.

2026-10-01: Tacit Sans Compact. The same face built 7 % narrower (tools/condense.py: every glyph, its anchors,
components, advance and kerning by 0.93, each master moved toward its neighbour so the stems keep their thickness)
with 18 units instead of 36 between capitals, as its own family for the browser's lists. Tacit Sans is unchanged.
Same day: Tacit Sans Display (x0.97, 24 units between capitals, every letter 14 units tighter a side) for titles, and
Tacit Sans Condensed (x0.86, 12 between capitals, 6 tighter a side) for tight places. tools/variant.sh makes each.
Later the same day: Display re-cut (x0.95, 16 between capitals, 26 tighter a side) and Condensed softened (x0.90, 18
between capitals, spacing as drawn); Tacit Code no longer joins == === !== (long bars read as a rule and hid the count).

1.001 (2026-10-25): Tacit Sans and its Compact, Condensed and Display cuts sit 50 units higher in the same 1250-unit
line (ascender 950, descender -300, in hhea and OS/2 typo), so a text box no longer ends on the tails of g, j, p, q
and y. Glyphs, spacing and Tacit Mono and Code are unchanged.
