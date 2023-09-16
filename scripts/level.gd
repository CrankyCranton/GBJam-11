class_name Level extends Node2D


@export var initial_speed := 32.0
@export var speed_increment := 2.0
@export var hook_speed_increment := 2.0

var speed_multiplier := 1.0
# Could be used in scoring
var y_pos := 0.0

@onready var speed := initial_speed
@onready var parallax: ParallaxBackground = $Parallax
@onready var hook: Hook = $Mothership/Hook
@onready var objects: Node2D = $Objects


func _init() -> void:
	randomize()


func _ready() -> void:
	hook_speed_increment = deg_to_rad(hook_speed_increment)


func _physics_process(delta: float) -> void:
	move(delta)


func move(delta: float) -> void:
	speed += speed_increment * delta
	var movement := speed * delta

	y_pos += movement
	speed_multiplier = speed / initial_speed
	print(speed_multiplier)
	hook.speed += hook_speed_increment * delta
	parallax.scroll_offset.y += movement
	for object in objects.get_children():
		object.position.y += movement


func _on_mothership_died(score: int) -> void:
	print("You collected %s trash." % score)
	get_tree().paused = true
