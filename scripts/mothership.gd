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

var trash := 0:
	set(value):
		trash = value
		score_counter.text = str(trash)
var start_time := Time.get_ticks_msec()
var immune := false

@onready var hp := max_hp:
	set(value):
		if immune:
			return

		hp = min(value, max_hp)
		if not is_node_ready():
			await ready
		health_bar.value = hp

		if hp <= 0:
			die()
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var score_counter: Label = $ScoreCounter


func die() -> void:
	@warning_ignore("integer_division")
	died.emit(trash, (Time.get_ticks_msec() - start_time) / 1000)
	$Explosions.emitting = true
	$BigExplosions.emitting = true
