extends RefCounted
class_name BattleUiTheme

const PARCHMENT := Color(0.72, 0.62, 0.43, 0.88)
const PARCHMENT_DARK := Color(0.30, 0.24, 0.17, 0.92)
const STONE_DARK := Color(0.09, 0.12, 0.14, 0.88)
const STONE_EDGE := Color(0.31, 0.36, 0.35, 1.0)
const RUST_EDGE := Color(0.52, 0.36, 0.20, 1.0)
const CRYSTAL := Color(0.20, 0.86, 0.94, 1.0)
const CRYSTAL_DARK := Color(0.08, 0.21, 0.31, 1.0)
const BLOOD := Color(0.60, 0.12, 0.10, 1.0)
const ATB := Color(0.34, 0.45, 0.95, 1.0)
const TEXT := Color(0.92, 0.86, 0.72, 1.0)


static func apply_panel(panel: Panel, variant := "stone") -> void:
	var style := StyleBoxFlat.new()
	if variant == "parchment":
		style.bg_color = PARCHMENT
		style.border_color = RUST_EDGE
	else:
		style.bg_color = STONE_DARK
		style.border_color = STONE_EDGE
	style.border_width_left = 4
	style.border_width_top = 4
	style.border_width_right = 4
	style.border_width_bottom = 4
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.42)
	style.shadow_size = 8
	panel.add_theme_stylebox_override("panel", style)


static func apply_label(label: Label, size := 26) -> void:
	label.add_theme_color_override("font_color", TEXT)
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.75))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.add_theme_font_size_override("font_size", size)


static func apply_button(button: Button) -> void:
	button.add_theme_font_size_override("font_size", 24)
	button.add_theme_color_override("font_color", TEXT)
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.96, 0.78, 1.0))
	button.add_theme_color_override("font_pressed_color", Color(0.74, 1.0, 1.0, 1.0))
	button.add_theme_stylebox_override("normal", _button_style(Color(0.20, 0.17, 0.13, 0.94), RUST_EDGE))
	button.add_theme_stylebox_override("hover", _button_style(Color(0.28, 0.23, 0.16, 0.96), Color(0.73, 0.53, 0.30, 1.0)))
	button.add_theme_stylebox_override("pressed", _button_style(Color(0.10, 0.22, 0.29, 0.98), CRYSTAL))
	button.add_theme_stylebox_override("disabled", _button_style(Color(0.10, 0.11, 0.11, 0.70), Color(0.22, 0.22, 0.21, 0.85)))


static func apply_bar(bar: ProgressBar, fill_color: Color) -> void:
	bar.add_theme_stylebox_override("background", _bar_style(Color(0.05, 0.06, 0.06, 0.92), Color(0.23, 0.20, 0.16, 1.0)))
	bar.add_theme_stylebox_override("fill", _bar_style(fill_color, fill_color.lightened(0.28)))
	bar.add_theme_font_size_override("font_size", 0)


static func _button_style(bg_color: Color, border_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.border_width_left = 4
	style.border_width_top = 4
	style.border_width_right = 4
	style.border_width_bottom = 4
	style.corner_radius_top_left = 7
	style.corner_radius_top_right = 7
	style.corner_radius_bottom_left = 7
	style.corner_radius_bottom_right = 7
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.35)
	style.shadow_size = 5
	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style


static func _bar_style(bg_color: Color, border_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5
	style.corner_radius_bottom_left = 5
	style.corner_radius_bottom_right = 5
	return style
