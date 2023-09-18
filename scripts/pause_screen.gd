class_name PauseScreen extends CanvasLayer


@onready var layout: Control = $Layout
@onready var continue_button: TextureButton = %ContinueButton
@onready var paused := false:
	set(value):
		if get_tree().paused == value:
			return

		paused = value
		get_tree().paused = paused
		layout.visible = paused
		if paused:
			continue_button.grab_focus()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		paused = not paused


func _on_continue_button_pressed() -> void:
	paused = false


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
