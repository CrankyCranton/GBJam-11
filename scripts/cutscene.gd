extends Node2D

var anim_num = 1

func _ready():
	$AnimationPlayer.play(str(anim_num))


func _process(delta):
	if Input.is_action_just_pressed("a"):
		anim_num += 1
		$AnimationPlayer.play(str(anim_num))
	if anim_num > 6:
		get_tree().change_scene_to_file("res://scenes/tutorial_level.tscn")
