class_name TextBox extends PanelContainer


signal finished

var continue_action := "start"

@onready var text: Label = $Text


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(continue_action) and visible:
		get_tree().paused = false
		hide()
		finished.emit()


@warning_ignore("shadowed_variable")
func print_text(message: String, continue_action := "start", location := PRESET_BOTTOM_WIDE) -> void:
	get_tree().paused = true
	text.text = message + "\n-%s to continue-" % continue_action
	self.continue_action = continue_action

	# Put off screen.
	set_position(Vector2(160.0, 0.0))
	show()

	await get_tree().process_frame
	set_anchors_and_offsets_preset(location)
