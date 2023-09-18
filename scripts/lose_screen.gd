class_name LoseScreen extends Control


const PASSWORD := "dSdai@?kZQ(@<Lyk%VBd*mD3SdhQ)RFw5BKj<bE+&muav~x%K~MR:KGjp!y].sF(][&{ey4b:9b4!SVZ7Q>97uW.GZF[H;@0a5^PdGHK<`t//A|j-Tv+B5M$gf5lgjX$"

@export var tally_speed := 1.0
@export var record_file_path := "user://record"

# score will tally up to this
var final_score := 0
var final_time := 0
var accepting_input := false

@onready var score_counter: Label = %ScoreCounter
@onready var score := 0:
	set(value):
		score = value
		score_counter.text = str(score)
@onready var record_counter: Label = %RecordCounter
@onready var record := 0:
	set(value):
		record = value
		record_counter.text = str(record)
@onready var time_counter: Label = %TimeCounter
@onready var time := 0:
	set(value):
		time = value
		@warning_ignore("integer_division")
		time_counter.text = "%s:%s:%s" % [time / 3600, time % 3600 / 60, time % 60]


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start"):
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/level.tscn")
	elif event.is_action_pressed("select"):
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/title_screen.tscn")


func load_record() -> int:
	if FileAccess.file_exists(record_file_path):
		var file := FileAccess.open_encrypted_with_pass(record_file_path, FileAccess.READ, PASSWORD)
		var error := FileAccess.get_open_error()
		if error == OK:
			return file.get_32()
		else:
			OS.alert("Unable to load record.\n" + error_string(error))
			return 0
	else:
		save_record(record)
		return record


@warning_ignore("shadowed_variable")
func save_record(record: int) -> void:
	var file := FileAccess.open_encrypted_with_pass(record_file_path, FileAccess.WRITE, PASSWORD)
	var error := FileAccess.get_open_error()
	if error == OK:
		file.store_32(record)
	else:
		OS.alert("Unable to save record.\n" + error_string(error))


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "lose":
		return

	create_tween().tween_property(self, "score", final_score, tally_speed)
	create_tween().tween_property(self, "record", load_record(), tally_speed)
	await create_tween().tween_property(self, "time", final_time, tally_speed).finished
	if final_score > record:
		save_record(final_score)

	$AnimationPlayer.play("suggest_restart")
	accepting_input = true
