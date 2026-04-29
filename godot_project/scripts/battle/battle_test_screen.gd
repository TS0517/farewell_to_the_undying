extends Control

const MANIFEST_PATH := "res://data/prototypes/battle_sprite_manifest.json"
const ALLY_GRID_TEXTURE_PATH := "res://assets/_incoming/battle_grid_ally_3x3_white_lines_transparent_v2.png"
const BattleUiThemeScript := preload("res://scripts/ui/battle_ui_theme.gd")
const UnitStatusPanelScene := preload("res://scenes/ui/BattleUnitStatusPanel.tscn")

const ALLY_GRID_POSITION := Vector2(360.0, 470.0)
const ALLY_GRID_TARGET_WIDTH := 720.0
const GRID_TOP_CORNER := Vector2(633.0, 553.0)
const GRID_COL_STEP := Vector2(121.0, 31.0)
const GRID_ROW_STEP := Vector2(-91.0, 72.0)
const ALLY_FOOT_VISUAL_ADJUST := Vector2(20.0, 16.0)
const MONSTER_HOME_POSITION := Vector2(930.0, 600.0)
const ENEMY_FOOT_BAR_SIZE := Vector2(420.0, 84.0)
const ENEMY_FOOT_BAR_OFFSET := Vector2(-210.0, 18.0)
const GRID_SELECT_RADIUS := 70.0
const ALLY_CLICK_HALF_WIDTH := 48.0
const ALLY_CLICK_HEIGHT := 146.0
const INVALID_POINT := Vector2(-100000.0, -100000.0)
const ACTION_RECOVERY_TIME := 0.42

const DIALOGUE_LINES := {
	"battle_start": [
		{"id": "battle_start_prince_001", "speaker": "王子", "text": "行くぞ。"}
	],
	"ally_attack": [
		{"id": "ally_attack_prince_001", "speaker": "", "text": "押し込む！"},
		{"id": "ally_attack_lio_001", "speaker": "", "text": "任せて！"},
		{"id": "ally_attack_mina_001", "speaker": "", "text": "今です！"},
		{"id": "ally_attack_garu_001", "speaker": "", "text": "道を開ける。"}
	],
	"ally_hit": [
		{"id": "ally_hit_001", "speaker": "", "text": "まだ戦える！"},
		{"id": "ally_hit_002", "speaker": "", "text": "気をつけて！"}
	],
	"ally_move": [
		{"id": "ally_move_001", "speaker": "", "text": "位置を変える。"}
	],
	"ally_death": [
		{"id": "ally_death_001", "speaker": "", "text": "すまない、下がる……"}
	],
	"enemy_defeated": [
		{"id": "enemy_defeated_001", "speaker": "王子", "text": "倒したぞ。"}
	]
}

const ALLY_TINTS := [
	Color(1.0, 1.0, 1.0, 1.0),
	Color(0.82, 0.95, 1.0, 1.0),
	Color(0.98, 0.86, 1.0, 1.0),
	Color(0.95, 1.0, 0.78, 1.0)
]

const ALLY_STARTERS := [
	{"name": "王子", "max_hp": 120.0, "atb_speed": 22.0, "attack_power": 14.0, "grid_position": Vector2i(0, 2)},
	{"name": "リオ", "max_hp": 100.0, "atb_speed": 26.0, "attack_power": 11.0, "grid_position": Vector2i(1, 2)},
	{"name": "ミナ", "max_hp": 90.0, "atb_speed": 18.0, "attack_power": 10.0, "grid_position": Vector2i(0, 1)},
	{"name": "ガル", "max_hp": 150.0, "atb_speed": 15.0, "attack_power": 17.0, "grid_position": Vector2i(1, 1)}
]

const ENEMY_STARTER := {
	"name": "森の魔物",
	"max_hp": 260.0,
	"atb_speed": 22.0,
	"attack_power": 22.0,
	"grid_position": Vector2i(-1, -1)
}

@onready var background: TextureRect = $Background
@onready var world: Node2D = $World
@onready var ally_grid_image: Sprite2D = $World/AllyGridImage
@onready var ally_actors: Array = [$World/HeroActor, $World/AllyActor2, $World/AllyActor3, $World/AllyActor4]
@onready var monster_actor: PoseSpriteActor = $World/MonsterActor
@onready var effects: Node2D = $World/Effects
@onready var monster_panel: Panel = $Hud/MonsterPanel
@onready var monster_name_label: Label = $Hud/MonsterPanel/NameLabel
@onready var monster_hp_value_label: Label = $Hud/MonsterPanel/HpValueLabel
@onready var monster_dead_label: Label = $Hud/MonsterPanel/DeadLabel
@onready var monster_hp_bar: ProgressBar = $Hud/MonsterPanel/HpBar
@onready var monster_atb_bar: ProgressBar = $Hud/MonsterPanel/AtbBar
@onready var unit_status_row: VBoxContainer = $Hud/UnitStatusPanelRow
@onready var dialogue_panel: Panel = $Hud/DialoguePanel
@onready var dialogue_speaker_label: Label = $Hud/DialoguePanel/SpeakerLabel
@onready var dialogue_line_label: Label = $Hud/DialoguePanel/LineLabel

var ally_units: Array = []
var enemy_unit: Dictionary = {}
var battle_finished := false
var selected_ally_index := -1
var selection_marker: Line2D


func _ready() -> void:
	randomize()
	_apply_battle_ui_theme()
	_setup_ally_grid_image()
	_create_selection_marker()

	var manifest := _load_manifest()
	_setup_visuals(manifest)
	_create_battle_units()
	_create_unit_status_panels()
	_update_all_ui()
	_say_random("battle_start")


func _process(delta: float) -> void:
	_update_enemy_foot_bar()
	_update_selection_marker()
	if battle_finished:
		return

	_tick_action_locks(delta)
	_tick_atb(delta)
	_try_start_ready_action()

	_update_all_ui()


func _unhandled_input(event: InputEvent) -> void:
	var pressed_position := _pressed_position(event)
	if pressed_position == INVALID_POINT:
		return

	if _try_select_ally_at(pressed_position):
		get_viewport().set_input_as_handled()
		return

	if selected_ally_index < 0:
		return

	var grid_position := _grid_position_at_point(pressed_position)
	if _is_valid_grid_position(grid_position):
		_try_move_selected_ally(grid_position)
		get_viewport().set_input_as_handled()
		return

	_clear_selection()
	get_viewport().set_input_as_handled()


func _load_manifest() -> Dictionary:
	var text := FileAccess.get_file_as_string(MANIFEST_PATH)
	var manifest = JSON.parse_string(text)
	if typeof(manifest) != TYPE_DICTIONARY:
		push_error("Failed to parse battle sprite manifest: %s" % MANIFEST_PATH)
		return {}
	return manifest


func _setup_visuals(manifest: Dictionary) -> void:
	var backgrounds: Dictionary = manifest.get("backgrounds", {})
	var background_path := str(backgrounds.get("battle_test", ""))
	if not background_path.is_empty():
		background.texture = _load_texture(background_path)

	var actors: Dictionary = manifest.get("actors", {})
	var hero_data: Dictionary = actors.get("hero_prince", {})
	var monster_data: Dictionary = actors.get("forest_beast", {})

	for index in ally_actors.size():
		var actor: PoseSpriteActor = ally_actors[index]
		actor.setup(hero_data)
		actor.set_tint(ALLY_TINTS[index])

	monster_actor.setup(monster_data)


func _create_battle_units() -> void:
	ally_units.clear()

	for index in ALLY_STARTERS.size():
		var source: Dictionary = ALLY_STARTERS[index]
		var grid_position: Vector2i = source["grid_position"]
		var actor: PoseSpriteActor = ally_actors[index]
		actor.set_home_position(_ally_foot_position(grid_position))
		actor.z_index = 2 + grid_position.y

		ally_units.append({
			"name": source["name"],
			"max_hp": source["max_hp"],
			"hp": source["max_hp"],
			"atb": 0.0,
			"atb_max": 100.0,
			"atb_speed": source["atb_speed"],
			"attack_power": source["attack_power"],
			"is_dead": false,
			"action_lock": 0.0,
			"grid_position": grid_position,
			"target": null,
			"actor": actor,
			"panel": null,
			"side": "ally"
		})

	monster_actor.set_home_position(MONSTER_HOME_POSITION)
	enemy_unit = {
		"name": ENEMY_STARTER["name"],
		"max_hp": ENEMY_STARTER["max_hp"],
		"hp": ENEMY_STARTER["max_hp"],
		"atb": 0.0,
		"atb_max": 100.0,
		"atb_speed": ENEMY_STARTER["atb_speed"],
		"attack_power": ENEMY_STARTER["attack_power"],
		"is_dead": false,
		"action_lock": 0.0,
		"grid_position": ENEMY_STARTER["grid_position"],
		"target": null,
		"actor": monster_actor,
		"panel": null,
		"side": "enemy"
	}

	for unit in ally_units:
		unit["target"] = enemy_unit


func _create_unit_status_panels() -> void:
	for child in unit_status_row.get_children():
		child.queue_free()

	for unit in ally_units:
		var panel := UnitStatusPanelScene.instantiate()
		unit_status_row.add_child(panel)
		unit["panel"] = panel


func _create_selection_marker() -> void:
	selection_marker = Line2D.new()
	selection_marker.width = 4.0
	selection_marker.default_color = Color(1.0, 0.88, 0.24, 0.95)
	selection_marker.closed = true
	selection_marker.points = PackedVector2Array([
		Vector2(0.0, -26.0),
		Vector2(52.0, 0.0),
		Vector2(0.0, 26.0),
		Vector2(-52.0, 0.0)
	])
	selection_marker.visible = false
	selection_marker.z_index = 4
	world.add_child(selection_marker)


func _setup_ally_grid_image() -> void:
	var texture := _load_texture(ALLY_GRID_TEXTURE_PATH)
	ally_grid_image.texture = texture
	ally_grid_image.centered = false
	ally_grid_image.position = ALLY_GRID_POSITION
	ally_grid_image.z_index = 1
	if texture == null:
		push_error("Missing ally grid texture: %s" % ALLY_GRID_TEXTURE_PATH)
		return

	var texture_width := float(texture.get_width())
	if texture_width > 0.0:
		var scale_value := ALLY_GRID_TARGET_WIDTH / texture_width
		ally_grid_image.scale = Vector2(scale_value, scale_value)


func _apply_battle_ui_theme() -> void:
	BattleUiThemeScript.apply_panel(monster_panel)
	BattleUiThemeScript.apply_panel(dialogue_panel, "parchment")
	BattleUiThemeScript.apply_label(monster_name_label, 22)
	BattleUiThemeScript.apply_label(monster_hp_value_label, 18)
	BattleUiThemeScript.apply_label(monster_dead_label, 20)
	BattleUiThemeScript.apply_label(dialogue_speaker_label, 24)
	BattleUiThemeScript.apply_label(dialogue_line_label, 30)
	monster_dead_label.add_theme_color_override("font_color", Color(1.0, 0.24, 0.18, 1.0))
	BattleUiThemeScript.apply_bar(monster_hp_bar, BattleUiThemeScript.BLOOD)
	BattleUiThemeScript.apply_bar(monster_atb_bar, BattleUiThemeScript.ATB)


func _tick_atb(delta: float) -> void:
	for unit in ally_units:
		if not _is_dead(unit):
			unit["atb"] = minf(float(unit["atb"]) + delta * float(unit["atb_speed"]), float(unit["atb_max"]))

	if not _is_dead(enemy_unit):
		enemy_unit["atb"] = minf(float(enemy_unit["atb"]) + delta * float(enemy_unit["atb_speed"]), float(enemy_unit["atb_max"]))


func _tick_action_locks(delta: float) -> void:
	for unit in ally_units:
		unit["action_lock"] = maxf(float(unit.get("action_lock", 0.0)) - delta, 0.0)

	if not enemy_unit.is_empty():
		enemy_unit["action_lock"] = maxf(float(enemy_unit.get("action_lock", 0.0)) - delta, 0.0)


func _try_start_ready_action() -> void:
	var ready_unit: Dictionary = {}
	for unit in ally_units:
		if _is_ready(unit) and (ready_unit.is_empty() or float(unit["atb"]) > float(ready_unit["atb"])):
			ready_unit = unit

	if _is_ready(enemy_unit) and (ready_unit.is_empty() or float(enemy_unit["atb"]) > float(ready_unit["atb"])):
		ready_unit = enemy_unit

	if not ready_unit.is_empty():
		_start_auto_attack(ready_unit)


func _start_auto_attack(attacker: Dictionary) -> void:
	if battle_finished or _is_dead(attacker) or _is_action_locked(attacker):
		return

	var target: Dictionary = enemy_unit if attacker.get("side", "") == "ally" else _select_enemy_target()
	attacker["target"] = target
	if target.is_empty():
		_check_battle_end()
		return

	attacker["atb"] = 0.0
	attacker["action_lock"] = ACTION_RECOVERY_TIME
	_perform_attack(attacker, target)
	_check_battle_end()
	_update_all_ui()


func _perform_attack(attacker: Dictionary, target: Dictionary) -> void:
	var attacker_actor: PoseSpriteActor = attacker["actor"]
	var target_actor: PoseSpriteActor = target["actor"]
	var direction := (target_actor.home_position - attacker_actor.home_position).normalized()
	var lunge_distance := 42.0 if attacker.get("side", "") == "ally" else 58.0

	attacker_actor.play_attack(direction * lunge_distance)
	_show_slash(_hit_position(target))
	_apply_damage(target, float(attacker["attack_power"]))
	_update_all_ui()

	if attacker.get("side", "") == "ally":
		_maybe_say_unit("ally_attack", attacker, 0.28)

	if _is_dead(target):
		if target.get("side", "") == "ally":
			_say_unit("ally_death", target)
		else:
			_say_random("enemy_defeated")
		target_actor.play_death()
	else:
		if attacker.get("side", "") == "enemy":
			_maybe_say_unit("ally_hit", target, 0.36)
		target_actor.play_hit()


func _apply_damage(target: Dictionary, damage: float) -> void:
	var next_hp := maxf(float(target["hp"]) - damage, 0.0)
	target["hp"] = next_hp
	if next_hp <= 0.0:
		target["is_dead"] = true
		target["atb"] = 0.0


func _check_battle_end() -> void:
	if _is_dead(enemy_unit):
		battle_finished = true
		enemy_unit["atb"] = 0.0
		return

	for unit in ally_units:
		if not _is_dead(unit):
			return

	battle_finished = true


func _select_enemy_target() -> Dictionary:
	var candidates: Array = []
	for unit in ally_units:
		if not _is_dead(unit):
			candidates.append(unit)
	if not candidates.is_empty():
		return candidates[randi() % candidates.size()]
	return {}


func _is_ready(unit: Dictionary) -> bool:
	return not _is_dead(unit) and not _is_action_locked(unit) and float(unit["atb"]) >= float(unit["atb_max"])


func _is_action_locked(unit: Dictionary) -> bool:
	return float(unit.get("action_lock", 0.0)) > 0.0


func _is_dead(unit: Dictionary) -> bool:
	return bool(unit.get("is_dead", false)) or float(unit.get("hp", 0.0)) <= 0.0


func _grid_cell_center(grid_position: Vector2i) -> Vector2:
	return GRID_TOP_CORNER + GRID_COL_STEP * (float(grid_position.x) + 0.5) + GRID_ROW_STEP * (float(grid_position.y) + 0.5)


func _ally_foot_position(grid_position: Vector2i) -> Vector2:
	return _grid_cell_center(grid_position) + ALLY_FOOT_VISUAL_ADJUST


func _pressed_position(event: InputEvent) -> Vector2:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			return mouse_event.position
	if event is InputEventScreenTouch:
		var touch_event := event as InputEventScreenTouch
		if touch_event.pressed:
			return touch_event.position
	return INVALID_POINT


func _try_select_ally_at(point: Vector2) -> bool:
	for index in range(ally_units.size() - 1, -1, -1):
		var unit: Dictionary = ally_units[index]
		if _is_dead(unit):
			continue
		if _ally_click_rect(unit).has_point(point):
			selected_ally_index = index
			_update_selection_marker()
			return true
	return false


func _ally_click_rect(unit: Dictionary) -> Rect2:
	var actor: PoseSpriteActor = unit["actor"]
	return Rect2(
		actor.home_position + Vector2(-ALLY_CLICK_HALF_WIDTH, -ALLY_CLICK_HEIGHT),
		Vector2(ALLY_CLICK_HALF_WIDTH * 2.0, ALLY_CLICK_HEIGHT + 20.0)
	)


func _grid_position_at_point(point: Vector2) -> Vector2i:
	var best_position := Vector2i(-1, -1)
	var best_distance := GRID_SELECT_RADIUS
	for y in range(3):
		for x in range(3):
			var grid_position := Vector2i(x, y)
			var distance := point.distance_to(_ally_foot_position(grid_position))
			if distance <= best_distance:
				best_distance = distance
				best_position = grid_position
	return best_position


func _is_valid_grid_position(grid_position: Vector2i) -> bool:
	return grid_position.x >= 0 and grid_position.x < 3 and grid_position.y >= 0 and grid_position.y < 3


func _try_move_selected_ally(grid_position: Vector2i) -> void:
	if selected_ally_index < 0 or selected_ally_index >= ally_units.size():
		_clear_selection()
		return

	var unit: Dictionary = ally_units[selected_ally_index]
	if _is_dead(unit):
		_clear_selection()
		return

	if unit["grid_position"] == grid_position:
		return

	if _is_grid_occupied(grid_position, selected_ally_index):
		return

	unit["grid_position"] = grid_position
	unit["atb"] = 0.0
	var actor: PoseSpriteActor = unit["actor"]
	actor.set_home_position(_ally_foot_position(grid_position))
	actor.z_index = 2 + grid_position.y
	_say_unit("ally_move", unit)
	_clear_selection()
	_update_all_ui()


func _is_grid_occupied(grid_position: Vector2i, ignore_index := -1) -> bool:
	for index in ally_units.size():
		if index == ignore_index:
			continue
		var unit: Dictionary = ally_units[index]
		if not _is_dead(unit) and unit["grid_position"] == grid_position:
			return true
	return false


func _clear_selection() -> void:
	selected_ally_index = -1
	_update_selection_marker()


func _update_selection_marker() -> void:
	if selection_marker == null:
		return
	if selected_ally_index < 0 or selected_ally_index >= ally_units.size():
		selection_marker.visible = false
		return
	var unit: Dictionary = ally_units[selected_ally_index]
	if _is_dead(unit):
		selected_ally_index = -1
		selection_marker.visible = false
		return
	var actor: PoseSpriteActor = unit["actor"]
	selection_marker.position = actor.home_position
	selection_marker.visible = true


func _hit_position(unit: Dictionary) -> Vector2:
	var actor: PoseSpriteActor = unit["actor"]
	return actor.home_position + (Vector2(0.0, -74.0) if unit.get("side", "") == "enemy" else Vector2(0.0, -26.0))


func _update_all_ui() -> void:
	for unit in ally_units:
		var panel: BattleUnitStatusPanel = unit["panel"]
		if panel == null:
			continue
		panel.set_unit_data({
			"name": unit["name"],
			"hp_text": "%d/%d" % [int(unit["hp"]), int(unit["max_hp"])],
			"hp_percent": _percent(unit["hp"], unit["max_hp"]),
			"atb_percent": _percent(unit["atb"], unit["atb_max"]),
			"is_dead": _is_dead(unit)
		})

	monster_name_label.text = str(enemy_unit.get("name", ""))
	monster_hp_value_label.text = "%d/%d" % [int(enemy_unit.get("hp", 0.0)), int(enemy_unit.get("max_hp", 0.0))]
	monster_hp_bar.value = _percent(enemy_unit.get("hp", 0.0), enemy_unit.get("max_hp", 1.0))
	monster_atb_bar.value = _percent(enemy_unit.get("atb", 0.0), enemy_unit.get("atb_max", 1.0))
	monster_dead_label.visible = _is_dead(enemy_unit)
	monster_hp_value_label.visible = not _is_dead(enemy_unit)
	monster_panel.modulate = Color(0.62, 0.62, 0.62, 0.9) if _is_dead(enemy_unit) else Color.WHITE
	_update_enemy_foot_bar()
	_update_selection_marker()


func _update_enemy_foot_bar() -> void:
	monster_panel.size = ENEMY_FOOT_BAR_SIZE
	var panel_position := monster_actor.home_position + ENEMY_FOOT_BAR_OFFSET
	var viewport_size := get_viewport_rect().size
	panel_position.x = clampf(panel_position.x, 24.0, viewport_size.x - ENEMY_FOOT_BAR_SIZE.x - 24.0)
	panel_position.y = clampf(panel_position.y, 80.0, viewport_size.y - ENEMY_FOOT_BAR_SIZE.y - 190.0)
	monster_panel.position = panel_position


func _say_random(category: String) -> void:
	var lines: Array = DIALOGUE_LINES.get(category, [])
	if lines.is_empty():
		return
	_apply_dialogue_line(lines[randi() % lines.size()], "")


func _say_unit(category: String, unit: Dictionary) -> void:
	var lines: Array = DIALOGUE_LINES.get(category, [])
	if lines.is_empty():
		return
	_apply_dialogue_line(lines[randi() % lines.size()], str(unit.get("name", "")))


func _maybe_say_unit(category: String, unit: Dictionary, chance: float) -> void:
	if randf() <= chance:
		_say_unit(category, unit)


func _apply_dialogue_line(line: Dictionary, fallback_speaker: String) -> void:
	var speaker := str(line.get("speaker", ""))
	if speaker.is_empty():
		speaker = fallback_speaker
	dialogue_speaker_label.text = speaker
	dialogue_line_label.text = str(line.get("text", ""))


func _percent(value: Variant, max_value: Variant) -> float:
	var max_float := maxf(float(max_value), 1.0)
	return clampf(float(value) / max_float * 100.0, 0.0, 100.0)


func _load_texture(path: String) -> Texture2D:
	if path.is_empty() or not ResourceLoader.exists(path, "Texture2D"):
		push_warning("Missing texture: %s" % path)
		return null
	var imported_texture := load(path)
	return imported_texture if imported_texture is Texture2D else null


func _show_slash(center_position: Vector2) -> void:
	var slash := Line2D.new()
	slash.width = 12.0
	slash.default_color = Color(1.0, 0.92, 0.45, 0.95)
	slash.points = PackedVector2Array([
		center_position + Vector2(-46.0, 38.0),
		center_position + Vector2(46.0, -38.0)
	])
	effects.add_child(slash)

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(slash, "width", 2.0, 0.16)
	tween.tween_property(slash, "modulate:a", 0.0, 0.16)
	tween.finished.connect(func() -> void:
		if is_instance_valid(slash):
			slash.queue_free()
	)
