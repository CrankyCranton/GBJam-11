class_name FlyingObject extends Area2D


signal destroyed

const DAMAGE_SOUND := preload("res://assets/sfx/hit_hurt.wav")

@export var damage := 1
@export var max_rot_speed := 45.0

var torque := 0.0

@onready var damage_sound: AudioStreamPlayer2D = $DamageSound


func _ready() -> void:
	max_rot_speed = deg_to_rad(max_rot_speed)
	torque = randf_range(-max_rot_speed, max_rot_speed)


func _physics_process(delta: float) -> void:
	rotate(torque * delta)


func destroy(attacker: Area2D) -> void:
	if attacker is FlyingObject:
		return

	if attacker is Mothership:
		deal_damage(attacker)

	destroyed.emit()
	queue_free()


func deal_damage(mothership: Mothership) -> void:
	mothership.hp -= damage
	play_sound()


func spawn_hit_effect() -> void:
	const BULLET_HIT_EFFECT := preload("res://scenes/bullet_hit_effect.tscn")
	var bullet_hit_effect := BULLET_HIT_EFFECT.instantiate()
	call_deferred("add_sibling", bullet_hit_effect)
	await bullet_hit_effect.ready
	bullet_hit_effect.global_position = global_position


func play_sound() -> void:
	damage_sound.reparent(get_parent())
	damage_sound.play()


func _on_area_entered(area: Area2D) -> void:
	spawn_hit_effect()
	destroy(area)
