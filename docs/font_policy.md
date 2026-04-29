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
res://assets/fonts/Hina_Mincho/HinaMincho-Regular.ttf
res://assets/fonts/Kaisei_Tokumin/KaiseiTokumin-Regular.ttf
res://assets/fonts/yuji-syuku/YujiSyuku-Regular.ttf
res://assets/fonts/EB_Garamond/static/EBGaramond-Regular.ttf
res://assets/fonts/Noto_Serif_SC/static/NotoSerifSC-Regular.ttf
```

The shared UI theme is:

```text
res://themes/main_theme.tres
```

## Implementation Notes

- `main_theme.tres` is the default UI theme for current scenes.
- `main_theme.tres` uses Hina Mincho as the default UI font.
- `TitleLabel` is the Kaisei Tokumin theme type for titles and large headings.
- `SpecialLabel` is the Yuji Syuku theme type for death notices, letters, gravestones, and other special dramatic text.
- EB Garamond and Noto Serif SC are connected as fallbacks in the theme font variations.
- Title and special text should use theme type variations, not ad hoc per-node font overrides.
- Keep localization IDs in scripts and data. Do not add new user-facing text directly in code when a localization table can own it.

## Future Theme Split

Recommended future theme types:

- `Label`: normal Hina Mincho UI and dialogue
- `TitleLabel`: Kaisei Tokumin headings
- `SpecialLabel`: Yuji Syuku dramatic text
- `Button`: Hina Mincho menu text unless the title screen image already contains the text
