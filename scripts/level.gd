class_name Level extends Node2D


@export var speed := 32.0
@export var speed_increment := 4.0

# Could be used in scoring
var y_pos := 0.0

@onready var parallax: ParallaxBackground = $Parallax
@onready var objects: Node2D = $Objects


func _init() -> void:
	randomize()


func _physics_process(delta: float) -> void:
	move(delta)


func move(delta: float) -> void:
	speed += speed_increment * delta
	var movement := speed * delta

	y_pos += movement
	parallax.scroll_offset.y += movement
	for object in objects.get_children():
		object.position.y += movement


func _on_mothership_died(score: int) -> void:
	print("You collected %s trash." % score)
	get_tree().paused = true
