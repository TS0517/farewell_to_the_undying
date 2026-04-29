extends Node

const TITLE_SCENE_PATH := "res://scenes/title/TitleScreen.tscn"
const BATTLE_TEST_SCENE_PATH := "res://scenes/battle/BattleTestScreen.tscn"


func change_to_title() -> void:
	_change_scene(TITLE_SCENE_PATH)


func change_to_battle_test() -> void:
	_change_scene(BATTLE_TEST_SCENE_PATH)


func quit_game() -> void:
	get_tree().quit()


func _change_scene(scene_path: String) -> void:
	var error := get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("Failed to change scene to %s: %s" % [scene_path, error])
