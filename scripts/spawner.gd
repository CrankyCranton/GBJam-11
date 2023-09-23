class_name Spawner extends Node2D


# Format: {<scene>: <probability>}
@export var spawn_list := {}
@export var add_to: Node
@export var min_spawn_dinstance := 32.0
@export var max_spawn_distance := 64.0

var current_spawn_distance := 0.0
var last_spawn: Node2D = null
var spawn_start_pos := Vector2()

@onready var min_pos: Marker2D = $MinPos
@onready var max_pos: Marker2D = $MaxPos


func _process(_delta: float) -> void:
	if (true if last_spawn == null or not is_instance_valid(last_spawn) else
			spawn_start_pos.distance_to(last_spawn.global_position) >= current_spawn_distance):
		spawn()


func spawn(scene: PackedScene = null) -> Node2D:
	current_spawn_distance = randf_range(min_spawn_dinstance, max_spawn_distance)
	if scene == null:
		scene = pick_spawn()
	var instance := scene.instantiate()
	add_to.call_deferred("add_child", instance)
	await instance.ready
	var raw_pos := min_pos.global_position.lerp(max_pos.global_position, randf())
	var cell_size := Vector2.ONE * 16.0
	instance.global_position = (raw_pos - cell_size / 2.0).snapped(cell_size) + cell_size / 2.0
	if not instance is UFO:
		last_spawn = instance
		spawn_start_pos = instance.global_position

	return instance


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
