class_name Spawner extends Node2D


# Format: {<scene>: <probability>}
@export var spawn_list := {}
@export var add_to: Node
# Should go by distance instead of time.
@export var max_spawn_time := 1.0

@onready var min_pos: Marker2D = $MinPos
@onready var max_pos: Marker2D = $MaxPos


func _ready() -> void:
	while true:
		await get_tree().create_timer(max_spawn_time).timeout
		spawn()


func spawn() -> void:
	var scene := pick_spawn()
	var instance := scene.instantiate()
	add_to.add_child(instance)
	instance.global_position = min_pos.global_position.lerp(max_pos.global_position, randf())


func pick_spawn() -> PackedScene:
	var total_priority: int = spawn_list.values().reduce(
		func(accum: int, num: int):
			return accum + num
	)
	var rand_num := randi_range(1, total_priority)
	var current_num := 0
	for key in spawn_list:
		var priority: int = spawn_list[key]
		if rand_num > current_num and rand_num <= current_num + priority:
			return key

		current_num += priority

	return null
