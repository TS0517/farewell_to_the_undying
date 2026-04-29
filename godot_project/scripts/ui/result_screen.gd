extends Control

@onready var retry_button: Button = $Panel/Buttons/RetryButton
@onready var title_button: Button = $Panel/Buttons/TitleButton


func _ready() -> void:
	retry_button.pressed.connect(_on_retry_pressed)
	title_button.pressed.connect(_on_title_pressed)


func _on_retry_pressed() -> void:
	SceneManager.change_to_battle_test()


func _on_title_pressed() -> void:
	SceneManager.change_to_title()
