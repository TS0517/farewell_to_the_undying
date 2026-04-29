# Font Assets

Place project font files in this folder. Godot should load these files through theme resources only; do not generate or process fonts at runtime.

Expected font roles and suggested filenames:

- Body / dialogue Japanese: `HinaMincho-Regular.ttf`
- Title / large heading Japanese: `KaiseiTokumin-Regular.ttf`
- Special text Japanese: `YujiSyuku-Regular.ttf`
- English fallback: `EBGaramond-Regular.ttf` or `EBGaramond-VariableFont_wght.ttf`
- Simplified Chinese fallback: `NotoSerifSC-Regular.otf` or `SourceHanSerifSC-Regular.otf`

The current `res://themes/main_theme.tres` works without these files by using Godot's default font. After the font files are added, create or update FontFile resources in the theme and set the regular UI font to the Hina Mincho chain.

Keep license files for each font in this folder or in `docs/licenses/fonts/`.
