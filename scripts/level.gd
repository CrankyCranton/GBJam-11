class_name Level extends Node2D


const LOSE_SCREEN := preload("res://scenes/lose_screen.tscn")

@export var speed_factor_increment := 0.01
@export var move_speed := 32.0

var speed_factor := 1.0
# Could be used in scoring
var y_pos := 0.0

@onready var parallax: ParallaxBackground = $Parallax
@onready var hook: Hook = $Mothership/Hook
@onready var objects: Node2D = $Objects
@onready var ship: Ship = $Ship


func _init() -> void:
	randomize()


func _physics_process(delta: float) -> void:
	move(delta)


func move(delta: float) -> void:
	speed_factor += speed_factor_increment * delta

	var movement := move_speed * speed_factor * delta
	y_pos += movement
	parallax.scroll_offset.y += movement
	for object in objects.get_children():
		object.position.y += movement

	hook.speed = Hook.START_SPEED * speed_factor
	ship.move_time = Ship.INITIAL_MOVE_TIME / speed_factor


func _on_mothership_died(score: int) -> void:
	var lose_screen := LOSE_SCREEN.instantiate()
	lose_screen.final_score = score
	add_child(lose_screen)
	get_tree().paused = true
