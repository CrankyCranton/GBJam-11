class_name Mothership extends Area2D


signal died(score: int, time: int)

# max_hp's & hp's setter functions are redundant
@export var max_hp := 1:
	set(value):
		max_hp = value
		hp = min(hp, max_hp)
		if not is_node_ready():
			await ready
		health_bar.max_value = max_hp

var trash := 0
var start_time := Time.get_ticks_msec()

@onready var hp := max_hp:
	set(value):
		hp = min(value, max_hp)
		if not is_node_ready():
			await ready
		health_bar.value = hp

		if hp <= 0:
			die()
@onready var health_bar: TextureProgressBar = $HealthBar


func die() -> void:
	@warning_ignore("integer_division")
	died.emit(trash, (Time.get_ticks_msec() - start_time) / 1000)
