class_name UFO extends FlyingObject


const BULLET := preload("res://scenes/bullet.tscn")


@export var strafe_speed := 16.0

var speed_multiplier := 1.0
var screen_width: float = ProjectSettings.get_setting("display/window/size/viewport_width")
var direction: int

@onready var barrel: Marker2D = $Barrel
@onready var shoot_sound: AudioStreamPlayer2D = %ShootSound


func _ready() -> void:
	randomize()
	direction = randi_range(0, 1) * 2 - 1
	set_physics_process(false)
	await get_tree().process_frame
	var movment := Vector2(0.0, 16.0)
	var move_time := 1.0
	await create_tween().tween_property(self, "position", position + movment, move_time).finished
	set_physics_process(true)
	$ShootTimer.start()


func _physics_process(delta: float) -> void:
	var movment := Vector2(strafe_speed * speed_multiplier * direction * delta, 0.0)
	var new_pos := global_position + movment
	var margin := 8.0
	if new_pos.x - margin < 0.0 or new_pos.x + margin > screen_width:
		direction = -direction
	else:
		global_position = new_pos


func _on_shoot_timer_timeout() -> void:
	shoot_sound.play()
	var bullet: Bullet = BULLET.instantiate()
	bullet.ufo_bullet = true
	get_tree().current_scene.call_deferred("add_child", bullet)
	await bullet.ready
	bullet.global_position = barrel.global_position
