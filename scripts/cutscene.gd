extends Node2D

var anim_num = 1
var finished = false

func _ready():
	$AnimationPlayer.play(str(anim_num))


func _process(delta):
	if Input.is_action_just_pressed("a") and finished == true:
		anim_num += 1
		$AnimationPlayer.play(str(anim_num))
		finished = false
	if anim_num > 6:
		get_tree().change_scene_to_file("res://scenes/tutorial_level.tscn")


func _on_animation_player_animation_finished(anim_name):
	finished = true
