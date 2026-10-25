# Changelog

## 0.1.0 (unreleased)

The first release: the parts of Tacit's own apps, for anyone making an app for Tacit.

- Tokens from one source (`tokens/tokens.json`); in apps they follow the user's wallpaper (`Live.qml`), with the
  desktop's own colour maths, and fall back to one palette (`Defaults.qml`).
- Lists: ListRow, RowList (one tab stop that owns the keyboard), SectionHeading, PictureGrid, CoverGrid (covers with
  a title and a line under each), JumpIndex.
- Places and pages: Rail, RailRow, RailSection, PageHeader (with a reading line), SearchField, PageState.
- Actions: Slab, WordAction, IconButton (with a tooltip that also shows on keyboard focus), MenuButton, Menu,
  MenuSurface, InlineLink.
- Panels: Docked, DockedPanel (the page lifted by a wash, hung from the header into the window's edge).
- Input: Field, Switch, Slider, Tabs.
- Feedback: Progress, Tooltip, FocusRing.
- Media: Transport, Waveform.
- Type and symbols: TacitText, Symbol.
- Scrolling: Glide (the touchpad follows the fingers and glides on; a mouse wheel steps).
- Tools: the generator, the render catalogue and the lint for apps.
- View controls: ViewBar (what is here, or the filter's fields; Filter, the order, the views as words) and FilterField.
  Menus take headings, a detail at a line's end and choices that keep the menu open.
- States for real apps: ListRow quiet, lead (a track number), accessory and a picture that falls back to its symbol;
  RailRow dropTarget, attention and accessory; Rail foot; Field input, error and persistentHint; Slab waiting and
  maxWidth; IconButton checked; RowList peeked (Space) apart from activated (Enter); PageState maxWidth.
- ListRow leadFigures (track numbers end in one column); PageHeader parents are tab stops; RailRow and Field disabled;
  Slider pressed; Progress, Slider and Waveform report their range to screen readers; DockedPanel label; the `scroll`
  motion token.
- JumpIndex fits a short list: the step shrinks, then the marks fold into dots (anchor its top and bottom).
- Check (ticked, not, mixed), Choices (one of a short set), Select (a value from a list, opens the Menu) and TextArea
  (multi-line Field: grows from minLines to maxLines, Ctrl+Enter submits, Esc dismisses).
- Notice (a line at the foot with at most one action: Undo), ScrollBar (thin, shows while the view moves or the pointer is near the edge), WindowGround (the window's ground at the user's see-through). New tokens: `width.scrollBar`, `motion.notice`, `motion.barStays`.
- Keyboard and screen reader fixes: IconButton, Slider and Switch use the Item's own `enabled` (disabled draws in the
  faint ink); Menu keys and accessibility sit on its content, menu lines are accessible items, the keyboard cursor has
  the focus ring; Field and SearchField expose the real TextInput; Slider steps with Up and Down and answers
  increase/decrease; Rail scrolls the focused row into view and folded rows name themselves; DockedPanel takes the
  keyboard when a key opens it and gives it back; PageState failures are alerts; `label` on RowList, PictureGrid,
  CoverGrid, Tabs, ViewBar and Transport; Tabs Home and End; `Kit.watchKeys(window)` shows the ring on the first Tab.
- Motion: every duration comes from a token (new: press, tone, reveal, dismiss, follow, sweep); `Kit.reducedMotion`
  (TACIT_REDUCED_MOTION=1) makes all of it 0 ms and stills the two endless stretches.
- Contrast: risk, meta and the menu's overlay inks (new roles overlayMeta, overlayRisk) reach Lc 75 on their grounds;
  the generator has an `inkFor` recipe for inks along another colour than the palette's on-background. A shell's
  Tacit.qml needs its token block regenerated (`generate.py qml`).
- PictureGrid and CoverGrid: the selection is a wash, the focus ring marks only the cursor.
- Removed: Sheet and Confirm, with the `scrim` colour and the `state.scrim` and `width.sheet` tokens that only they
  read. An app asks in place now: names in their row, Undo for what can be undone, the action itself confirms what
  cannot.
- Added: ListRow `editing` (the name becomes a line to type in where it is, the stem chosen; `editAll`, `fresh`,
  `label`; `renamed(text)`, `editCancelled()`; `previewState: "editing"`) and RowList `editRequested(index)` on F2.
- Added: Slab and WordAction `confirm` (the first press turns the words into the question in the risk tone, a second
  press does it; `confirmCancelled()`; `previewState: "confirming"`) and the `motion.confirmWait` token (4 s).
- Changed: one word per meaning for what the user did. `activated` is do the thing, `picked` is choose one of a set,
  `toggled` is on or off. Renamed: IconButton, MenuButton `pressed()`, Slab, WordAction `picked()`, Notice, PageState
  `acted()` and Rail `actionPicked()` are all `activated()` (Rail: `actionActivated()`).
