class_name TitleScreen extends Control


const LEVEL := "res://scenes/level.tscn"
const CUTSCENE := "res://scenes/cutscene.tscn"

@onready var tutorial_button: TextureButton = %TutorialButton


func _ready() -> void:
	get_tree().paused = false
	#$Title.text = ProjectSettings.get_setting("application/config/name")
	%StartButton.grab_focus()
	if Data.data.first_time:
		tutorial_button.hide()



func _on_start_button_pressed() -> void:
	var scene
	if Data.data.first_time:
		get_tree().change_scene_to_file(CUTSCENE)
	else:
		get_tree().change_scene_to_file(LEVEL)


func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file(CUTSCENE)
