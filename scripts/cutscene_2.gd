class_name Cutscene2 extends Sprite2D


@onready var next_prompt: Label = $NextPrompt


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start"):
		if frame >= hframes * vframes - 1:
			get_tree().change_scene_to_file("res://scenes/tutorial_level.tscn")
		else:
			frame += 1
			if frame > 0:
				next_prompt.set("theme_override_colors/font_outline_color", Color("0c5066"))
			set_process_input(false)
			await get_tree().create_timer(1.0).timeout
			set_process_input(true)
