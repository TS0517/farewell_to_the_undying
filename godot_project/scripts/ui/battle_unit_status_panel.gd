extends Control
class_name BattleUnitStatusPanel

const REQUESTED_PANEL_TEXTURE_PATH := "res://assets/_incoming/battle_unit_status_panel.png"
const BattleUiThemeScript := preload("res://scripts/ui/battle_ui_theme.gd")

@onready var panel_backing: Panel = $PanelBacking
@onready var background: TextureRect = $Background
@onready var face_frame: ColorRect = $FaceFrame
@onready var face_texture: TextureRect = $FaceFrame/FaceTexture
@onready var face_placeholder: ColorRect = $FaceFrame/FacePlaceholder
@onready var name_label: Label = $NameLabel
@onready var hp_value_label: Label = $HpValueLabel
@onready var hp_bar: ProgressBar = $HpBar
@onready var atb_bar: ProgressBar = $AtbBar
@onready var dead_label: Label = $DeadLabel

var _pending_data: Dictionary = {}


func _ready() -> void:
	_apply_style()
	_load_panel_background()
	if not _pending_data.is_empty():
		set_unit_data(_pending_data)


func set_unit_data(data: Dictionary) -> void:
	_pending_data = data
	if not is_node_ready():
		return

	name_label.text = str(data.get("name", ""))
	hp_value_label.text = str(data.get("hp_text", "0/0"))
	hp_bar.value = float(data.get("hp_percent", 0.0))
	atb_bar.value = float(data.get("atb_percent", 0.0))
	var is_dead := bool(data.get("is_dead", false))
	dead_label.visible = is_dead
	modulate = Color(0.58, 0.58, 0.58, 0.88) if is_dead else Color.WHITE

	var face_path := str(data.get("face_path", ""))
	if face_path.is_empty():
		face_texture.texture = null
		face_texture.visible = false
		face_placeholder.visible = true
		return

	var texture := _load_texture(face_path)
	face_texture.texture = texture
	face_texture.visible = texture != null
	face_placeholder.visible = texture == null


func _load_panel_background() -> void:
	var texture := _load_texture(REQUESTED_PANEL_TEXTURE_PATH)
	if texture == null:
		push_error("Missing unit status panel texture: %s" % REQUESTED_PANEL_TEXTURE_PATH)
		panel_backing.visible = true
		background.visible = false
		return
	background.texture = texture
	background.visible = true
	panel_backing.visible = false


func _apply_style() -> void:
	BattleUiThemeScript.apply_label(name_label, 20)
	BattleUiThemeScript.apply_label(hp_value_label, 16)
	BattleUiThemeScript.apply_label(dead_label, 18)
	dead_label.add_theme_color_override("font_color", Color(1.0, 0.24, 0.18, 1.0))
	_apply_embedded_bar(hp_bar, Color(0.76, 0.12, 0.10, 0.92))
	_apply_embedded_bar(atb_bar, Color(0.23, 0.34, 0.96, 0.92))
	name_label.z_index = 2
	hp_value_label.z_index = 2
	dead_label.z_index = 3
	face_frame.z_index = 2
	hp_bar.z_index = 1
	atb_bar.z_index = 1
	face_frame.color = Color(0.06, 0.08, 0.08, 0.78)
	face_placeholder.color = Color(0.13, 0.21, 0.24, 0.82)


func _apply_embedded_bar(bar: ProgressBar, fill_color: Color) -> void:
	var background_style := StyleBoxFlat.new()
	background_style.bg_color = Color(0.015, 0.018, 0.024, 0.86)
	bar.add_theme_stylebox_override("background", background_style)

	var fill_style := StyleBoxFlat.new()
	fill_style.bg_color = fill_color
	fill_style.corner_radius_top_left = 3
	fill_style.corner_radius_top_right = 3
	fill_style.corner_radius_bottom_left = 3
	fill_style.corner_radius_bottom_right = 3
	bar.add_theme_stylebox_override("fill", fill_style)
	bar.add_theme_font_size_override("font_size", 0)


func _load_texture(path: String) -> Texture2D:
	if path.is_empty() or not ResourceLoader.exists(path, "Texture2D"):
		return null
	var imported_texture := load(path)
	return imported_texture if imported_texture is Texture2D else null
