class_name BulletHitEffect extends AnimatedSprite2D


func _ready() -> void:
	play("explode")


func _on_animation_finished() -> void:
	queue_free()
