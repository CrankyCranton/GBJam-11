class_name Level extends Node2D


const LOSE_SCREEN := preload("res://scenes/lose_screen.tscn")

@export var speed_factor_increment := 0.01
@export var move_speed := 32.0

var additional_object_queue := [
	[preload("res://scenes/obstacle_tough.tscn"), 4],
	[preload("res://scenes/ufo.tscn"), 2],
]
var speed_factor := 1.0
# Could be used in scoring
var y_pos := 0.0

@onready var parallax: ParallaxBackground = $Parallax
@onready var hook: Hook = $Mothership/Hook
@onready var objects: Node2D = $Objects
@onready var ship: Ship = $Ship
@onready var stars: GPUParticles2D = %Stars
@onready var planets: GPUParticles2D = %Planets
@onready var spawner: Spawner = $Spawner


func _init() -> void:
	randomize()


func _physics_process(delta: float) -> void:
	move(delta)


func move(delta: float) -> void:
	speed_factor += speed_factor_increment * delta

	var movement := move_speed * speed_factor * delta
	y_pos += movement
	stars.process_material.set("initial_velocity_min", move_speed * speed_factor / 2.0)
	stars.process_material.set("initial_velocity_max", move_speed * speed_factor / 2.0)
	planets.process_material.set("initial_velocity_min", move_speed * speed_factor / 5.0)
	planets.process_material.set("initial_velocity_max", move_speed * speed_factor / 5.0)
	parallax.scroll_offset.y += movement
	for object in objects.get_children():
		if object is UFO:
			object.speed_multiplier = speed_factor
		else:
			object.position.y += movement * object.speed

	hook.speed = Hook.START_SPEED * speed_factor
	ship.move_time = Ship.INITIAL_MOVE_TIME / speed_factor


func _on_mothership_died(score: int, time: int) -> void:
	var lose_screen := LOSE_SCREEN.instantiate()
	lose_screen.final_score = score
	lose_screen.final_time = time
	add_child(lose_screen)
	get_tree().paused = true


func _on_upgrade_timer_timeout() -> void:
	if additional_object_queue.size() <= 0:
		return
	var new_object: Array = additional_object_queue.pop_front()
	spawner.spawn_list[new_object[0]] = new_object[1]
