class_name Mothership extends Area2D


signal died(score: int)

var trash := 0

# max_hp's & hp's setter functions are redundant
@export var max_hp := 1:
	set(value):
		max_hp = value
		hp = min(hp, max_hp)
		if not is_node_ready():
			await ready
		health_bar.max_value = max_hp

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
	died.emit(trash)
