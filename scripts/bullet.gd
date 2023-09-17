class_name Bullet extends Area2D


@export var speed := 256.0

@onready var destroy_sound: AudioStreamPlayer2D = $DestroySound


func _physics_process(delta: float) -> void:
	translate(Vector2(0.0, -speed * delta))


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is FlyingObject:
		destroy_sound.play()
		destroy_sound.reparent(get_parent())
		destroy_sound.play()
		queue_free()
