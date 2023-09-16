class_name Hook extends ShapeCast2D


signal anim_hooked

@export var max_angle := 85.0
@export var speed := 180.0
@export var haul_time := 0.5
@export var launch_speed := 512.0

var direction := 1
var hauling := false

@onready var chain: TextureRect = $Chain
@onready var hook_sprite: Sprite2D = $HookSprite


func _ready() -> void:
	max_angle = deg_to_rad(max_angle)
	speed = deg_to_rad(speed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("b") and not hauling:
		launch()


func _physics_process(delta: float) -> void:
	if hauling:
		return

	if abs(rotation) >= max_angle:
		direction = -direction

	rotation += speed * direction * delta


func launch() -> void:
	hauling = true
	enabled = true
	force_shapecast_update()

	var distance := 200.0
	if is_colliding() and get_collider(0) is Object:
		var object: FlyingObject = get_collider(0)
		haul_object(object)
		distance = global_position.distance_to(object.global_position)

	var launch_duration := distance / launch_speed
	create_tween().tween_property(chain, "size:y", distance, launch_duration)
	var hook_tween := create_tween().tween_property(hook_sprite, "position:y", -distance,
			launch_duration)
	await hook_tween.finished
	anim_hooked.emit()

	create_tween().tween_property(chain, "size:y", 4, launch_duration)
	var draw_tween := get_tree().create_tween()
	draw_tween.tween_property(hook_sprite, "position:y", 0, launch_duration)
	await draw_tween.finished

	hauling = false
	enabled = false


func haul_object(object: Object) -> void:
	if object is Trash:
		object.collected = true
	await anim_hooked
	create_tween().tween_property(object, "global_position", global_position, haul_time)
