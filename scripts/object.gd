class_name FlyingObject extends Area2D


@export var damage := 1


func _on_area_entered(area: Area2D) -> void:
	if area is FlyingObject:
		return
	queue_free()
