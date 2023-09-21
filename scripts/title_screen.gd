class_name TitleScreen extends Control


func _ready() -> void:
	get_tree().paused = false
	#$Title.text = ProjectSettings.get_setting("application/config/name")
	%TutorialButton.grab_focus()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tutorial_level.tscn")
