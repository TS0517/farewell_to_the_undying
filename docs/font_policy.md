# Font Policy

## Roles

- Normal dialogue and body text: Hina Mincho
- Titles and large headings: Kaisei Tokumin
- Death notices, letters, gravestones, and other special dramatic text: Yuji Syuku
- English fallback: EB Garamond
- Simplified Chinese fallback: Noto Serif SC or Source Han Serif SC

## Godot Paths

Font files should be placed under:

```text
res://assets/fonts/
```

Suggested filenames:

```text
res://assets/fonts/HinaMincho-Regular.ttf
res://assets/fonts/KaiseiTokumin-Regular.ttf
res://assets/fonts/YujiSyuku-Regular.ttf
res://assets/fonts/EBGaramond-Regular.ttf
res://assets/fonts/NotoSerifSC-Regular.otf
```

The shared UI theme is:

```text
res://themes/main_theme.tres
```

## Implementation Notes

- `main_theme.tres` is the default UI theme for current scenes.
- Until font files are added, the theme intentionally falls back to Godot's default font.
- After adding fonts, update `main_theme.tres` to set the default font to the Hina Mincho font resource.
- Title and special text should use separate theme types or explicit font overrides later, not ad hoc per-node styling.
- Keep localization IDs in scripts and data. Do not add new user-facing text directly in code when a localization table can own it.

## Future Theme Split

Recommended future theme types:

- `Label`: normal Hina Mincho UI and dialogue
- `TitleLabel`: Kaisei Tokumin headings
- `SpecialLabel`: Yuji Syuku dramatic text
- `Button`: Hina Mincho menu text unless the title screen image already contains the text
