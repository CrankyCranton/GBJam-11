class_name Trash extends FlyingObject


@export var max_rot_speed := 45.0
@export var value := 1
@export var health_value := 1

var torque := 0.0
var collected := false


func _ready() -> void:
	max_rot_speed = deg_to_rad(max_rot_speed)
	torque = randf_range(-max_rot_speed, max_rot_speed)


func _physics_process(delta: float) -> void:
	rotate(torque * delta)
