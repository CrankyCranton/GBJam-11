class_name Bullet extends Area2D


@export var speed := 256.0

var ufo_bullet := false


func _physics_process(delta: float) -> void:
	translate(Vector2(0.0, speed * (int(ufo_bullet) * 2 - 1) * delta))


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if (area is FlyingObject and not ufo_bullet):
		queue_free()
	elif area is Mothership:
		area.hp -= 1
		var hit_effect: BulletHitEffect = preload("res://scenes/bullet_hit_effect.tscn").instantiate()
		get_tree().current_scene.call_deferred("add_child", hit_effect)
		await hit_effect.ready
		hit_effect.global_position = global_position
		queue_free()
