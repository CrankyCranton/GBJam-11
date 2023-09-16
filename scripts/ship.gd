class_name Ship extends Sprite2D


const BULLET := preload("res://scenes/bullet.tscn")
const INITIAL_MOVE_TIME := 0.15

@export var move_time := INITIAL_MOVE_TIME
@export var move_increment := 16.0
@export var tween_factor := 0.5
@export var cool_down := 0.25

var moving := false
var screen_width: float = ProjectSettings.get_setting("display/window/size/viewport_width")
var cooling := false

@onready var barrel: Marker2D = $Barrel
@onready var shoot_sound: AudioStreamPlayer2D = %ShootSound


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("a") and not cooling:
		shoot()


func _physics_process(_delta: float) -> void:
	move()


func move() -> void:
	if moving:
		return

	@warning_ignore("narrowing_conversion")
	var input: int = Input.get_action_strength("dpad_right") - Input.get_action_strength("dpad_left")
	var new_pos :=  position + Vector2(input * move_increment, 0.0)
	if input and new_pos.x > 0.0 and new_pos.x < screen_width:
		create_tween().tween_property(self, "position", new_pos, move_time * tween_factor)
		moving = true
		await get_tree().create_timer(move_time).timeout
		moving = false


func shoot() -> void:
	var bullet := BULLET.instantiate()
	add_child(bullet)
	bullet.global_position = barrel.global_position
	shoot_sound.play()
