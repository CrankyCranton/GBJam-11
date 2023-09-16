class_name Hook extends ShapeCast2D


signal anim_hooked

const START_SPEED := PI

@export var max_angle := 85.0
@export var haul_time := 0.5
@export var launch_speed := 512.0

var direction := 1
var hauling := false
var speed := START_SPEED

@onready var chain: TextureRect = $Chain
@onready var hook_sprite: Sprite2D = $HookSprite


func _ready() -> void:
	max_angle = deg_to_rad(max_angle)


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
	if is_colliding() and get_collider(0) is FlyingObject:
		var object: FlyingObject = get_collider(0)
		haul_object(object)
		distance = global_position.distance_to(object.global_position)

	enabled = false

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


func haul_object(object: FlyingObject) -> void:
	var object_shape: CollisionShape2D = object.get_node("CollisionShape2D")
	object_shape.set_deferred("disabled", true)
	if object is Trash:
		object.collected = true
	await anim_hooked
	if is_instance_valid(object):
		var tween := create_tween().tween_property(object, "global_position", global_position, haul_time)
		await tween.finished
		object_shape.set_deferred("disabled", false)
