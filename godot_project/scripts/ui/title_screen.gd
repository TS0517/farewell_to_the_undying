extends Control

@onready var start_button: Button = $MenuHitArea/StartButton
@onready var continue_button: Button = $MenuHitArea/ContinueButton
@onready var quit_button: Button = $MenuHitArea/QuitButton
@onready var notice_panel: Panel = $NoticePanel
@onready var notice_label: Label = $NoticePanel/NoticeLabel

var _notice_tween: Tween


func _ready() -> void:
	_apply_title_theme()
	start_button.pressed.connect(_on_start_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _on_start_pressed() -> void:
	SceneManager.change_to_battle_test()


func _on_continue_pressed() -> void:
	print("Continue is not implemented yet.")
	_show_notice("つづきから はまだ未実装です")


func _on_quit_pressed() -> void:
	SceneManager.quit_game()


func _apply_title_theme() -> void:
	for button in [start_button, continue_button, quit_button]:
		button.flat = true
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.add_theme_stylebox_override("normal", _button_style(Color(0.0, 0.0, 0.0, 0.0), Color(0.0, 0.0, 0.0, 0.0)))
		button.add_theme_stylebox_override("hover", _button_style(Color(0.95, 0.78, 0.36, 0.13), Color(0.26, 0.13, 0.04, 0.42)))
		button.add_theme_stylebox_override("pressed", _button_style(Color(0.55, 0.34, 0.13, 0.20), Color(0.18, 0.09, 0.03, 0.55)))
		button.add_theme_stylebox_override("focus", _button_style(Color(1.0, 0.86, 0.45, 0.12), Color(0.20, 0.10, 0.03, 0.5)))
		button.add_theme_color_override("font_color", Color(0.0, 0.0, 0.0, 0.0))
		button.add_theme_color_override("font_hover_color", Color(0.0, 0.0, 0.0, 0.0))
		button.add_theme_color_override("font_pressed_color", Color(0.0, 0.0, 0.0, 0.0))
		button.add_theme_color_override("font_focus_color", Color(0.0, 0.0, 0.0, 0.0))

	notice_panel.modulate.a = 0.0
	notice_panel.visible = false
	notice_label.add_theme_color_override("font_color", Color(0.12, 0.08, 0.04, 1.0))
	notice_panel.add_theme_stylebox_override("panel", _notice_style())


func _button_style(fill_color: Color, border_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill_color
	style.border_color = border_color
	style.set_border_width_all(2)
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_left = 6
	style.corner_radius_bottom_right = 6
	style.content_margin_left = 0.0
	style.content_margin_right = 0.0
	style.content_margin_top = 0.0
	style.content_margin_bottom = 0.0
	return style


func _notice_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.82, 0.68, 0.43, 0.82)
	style.border_color = Color(0.28, 0.17, 0.07, 0.72)
	style.set_border_width_all(3)
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_left = 6
	style.corner_radius_bottom_right = 6
	return style


func _show_notice(message: String) -> void:
	if _notice_tween != null and _notice_tween.is_valid():
		_notice_tween.kill()

	notice_label.text = message
	notice_panel.visible = true
	notice_panel.modulate.a = 0.0

	_notice_tween = create_tween()
	_notice_tween.tween_property(notice_panel, "modulate:a", 1.0, 0.12)
	_notice_tween.tween_interval(1.8)
	_notice_tween.tween_property(notice_panel, "modulate:a", 0.0, 0.28)
	_notice_tween.finished.connect(func() -> void:
		notice_panel.visible = false
	)
