class_name Trash extends FlyingObject


@export var max_rot_speed := 45.0
@export var value := 1
@export var health_value := 1
@export var trash_dir := "res://assets/trash/"

var torque := 0.0
var collected := false

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	max_rot_speed = deg_to_rad(max_rot_speed)
	torque = randf_range(-max_rot_speed, max_rot_speed)
	load_sprite()


func _physics_process(delta: float) -> void:
	rotate(torque * delta)


func load_sprite() -> void:
	var sprites := Array(DirAccess.get_files_at(trash_dir)).filter(
		func(value: String):
			return value.ends_with(".png")
	)
	sprite.texture = load(trash_dir + sprites.pick_random())


func deal_damage(mothership: Mothership) -> void:
	if collected:
		mothership.trash += value
		mothership.hp += health_value
	else:
		super(mothership)


func _on_area_entered(area: Area2D) -> void:
	if collected:
		if area is Mothership:
			destroy(area)
	else:
		super(area)
