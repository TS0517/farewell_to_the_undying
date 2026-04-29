extends Sprite2D
class_name PoseSpriteActor

const REQUIRED_POSES := ["idle", "attack", "hit", "skill", "death"]

var pose_textures: Dictionary = {}
var home_position := Vector2.ZERO
var base_scale := Vector2.ONE
var base_modulate := Color.WHITE
var foot_anchor_ratio := Vector2(0.5, 0.88)
var current_pose := "idle"
var is_dead := false
var _animation_token := 0
var _active_tween: Tween


func setup(actor_data: Dictionary) -> void:
	pose_textures.clear()
	var states: Dictionary = actor_data.get("states", {})
	for pose_name in REQUIRED_POSES:
		var path := str(states.get(pose_name, ""))
		if path.is_empty():
			push_warning("Missing pose path: %s" % pose_name)
			continue
		var pose_texture := _load_texture(path)
		if pose_texture == null:
			push_warning("Failed to load pose texture: %s" % path)
			continue
		pose_textures[pose_name] = pose_texture

	var display_scale := float(actor_data.get("display_scale", 1.0))
	foot_anchor_ratio = Vector2(float(actor_data.get("foot_anchor_x", 0.5)), float(actor_data.get("foot_anchor_y", 0.88)))
	base_scale = Vector2(display_scale, display_scale)
	scale = base_scale
	modulate = base_modulate
	is_dead = false
	set_pose("idle")


func _load_texture(path: String) -> Texture2D:
	if path.is_empty() or not ResourceLoader.exists(path, "Texture2D"):
		return null
	var imported_texture := load(path)
	return imported_texture if imported_texture is Texture2D else null


func set_tint(value: Color) -> void:
	base_modulate = value
	modulate = value


func set_home_position(value: Vector2) -> void:
	home_position = value
	position = value


func set_pose(pose_name: String) -> void:
	if not pose_textures.has(pose_name):
		return
	current_pose = pose_name
	texture = pose_textures[pose_name]
	_apply_foot_anchor()


func _apply_foot_anchor() -> void:
	if texture == null:
		return
	centered = false
	offset = -Vector2(float(texture.get_width()) * foot_anchor_ratio.x, float(texture.get_height()) * foot_anchor_ratio.y)


func reset_actor() -> void:
	is_dead = false
	_animation_token += 1
	_kill_active_tween()
	modulate = base_modulate
	scale = base_scale
	position = home_position
	set_pose("idle")


func play_attack(offset: Vector2) -> void:
	if is_dead:
		return
	_animation_token += 1
	var token := _animation_token
	set_pose("attack")
	modulate = base_modulate
	scale = base_scale

	var forward_position := home_position + offset
	var tween := _create_actor_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", forward_position, 0.18)
	tween.tween_interval(0.08)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", home_position, 0.22)
	tween.finished.connect(_finish_temporary_pose.bind(token))


func play_hit() -> void:
	if is_dead:
		return
	_animation_token += 1
	var token := _animation_token
	set_pose("hit")
	scale = base_scale
	modulate = Color(1.0, 0.22, 0.22, 1.0)

	var tween := _create_actor_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", home_position + Vector2(-16.0, 3.0), 0.045)
	tween.tween_property(self, "position", home_position + Vector2(14.0, -2.0), 0.045)
	tween.tween_property(self, "position", home_position, 0.07)
	tween.parallel().tween_property(self, "modulate", base_modulate, 0.16)
	tween.finished.connect(_finish_temporary_pose.bind(token))


func play_skill() -> void:
	if is_dead:
		return
	_animation_token += 1
	var token := _animation_token
	set_pose("skill")
	position = home_position
	modulate = base_modulate.lerp(Color(1.25, 1.15, 0.62, 1.0), 0.55)

	var tween := _create_actor_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", base_scale * 1.18, 0.22)
	tween.tween_property(self, "modulate", Color(1.6, 1.35, 0.72, 1.0), 0.22)
	tween.tween_property(self, "scale", base_scale, 0.24)
	tween.parallel().tween_property(self, "modulate", base_modulate, 0.24)
	tween.finished.connect(_finish_temporary_pose.bind(token))


func play_death() -> void:
	if is_dead:
		return
	is_dead = true
	_animation_token += 1
	set_pose("death")
	position = home_position
	modulate = base_modulate

	var tween := _create_actor_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", base_scale * 0.72, 0.82)
	tween.tween_property(self, "modulate:a", 0.0, 0.82)


func _create_actor_tween() -> Tween:
	_kill_active_tween()
	_active_tween = create_tween()
	return _active_tween


func _kill_active_tween() -> void:
	if _active_tween != null and _active_tween.is_valid():
		_active_tween.kill()
	_active_tween = null


func _finish_temporary_pose(token: int) -> void:
	if token != _animation_token or is_dead:
		return
	_active_tween = null
	position = home_position
	scale = base_scale
	modulate = base_modulate
	set_pose("idle")
