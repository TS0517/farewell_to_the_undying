# Font Assets

Place project font files in this folder. Godot should load these files through theme resources only; do not generate or process fonts at runtime.

Expected font roles and current filenames:

- Body / dialogue Japanese: `Hina_Mincho/HinaMincho-Regular.ttf`
- Title / large heading Japanese: `Kaisei_Tokumin/KaiseiTokumin-Regular.ttf`
- Special text Japanese: `yuji-syuku/YujiSyuku-Regular.ttf`
- English fallback: `EB_Garamond/static/EBGaramond-Regular.ttf`
- Simplified Chinese fallback: `Noto_Serif_SC/static/NotoSerifSC-Regular.ttf`

The current `res://themes/main_theme.tres` connects these files directly. Keep the paths stable, or update the theme resource if files are moved.

Keep license files for each font in this folder or in `docs/licenses/fonts/`.
