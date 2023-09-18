class_name FlyingObject extends Area2D


signal destroyed

const DAMAGE_SOUND := preload("res://assets/sfx/hit_hurt.wav")

@export var damage := 1

@onready var damage_sound: AudioStreamPlayer2D = $DamageSound


func _on_area_entered(area: Area2D) -> void:
	if area is FlyingObject:
		return

	if area is Mothership:
		deal_damage(area)

	destroyed.emit()
	queue_free()


func deal_damage(mothership: Mothership) -> void:
	mothership.hp -= damage
	play_sound()


func play_sound() -> void:
	damage_sound.reparent(get_parent())
	damage_sound.play()
