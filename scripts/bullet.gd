class_name Bullet extends Area2D


const BULLET_HIT_EFFECT := preload("res://scenes/bullet_hit_effect.tscn")

@export var speed := 256.0


func _physics_process(delta: float) -> void:
	translate(Vector2(0.0, -speed * delta))


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is FlyingObject:
		var object_pos := area.global_position
		var bullet_hit_effect := BULLET_HIT_EFFECT.instantiate()
		call_deferred("add_sibling", bullet_hit_effect)
		await bullet_hit_effect.ready
		bullet_hit_effect.global_position = object_pos
		queue_free()
