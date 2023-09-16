class_name FlyingObject extends Area2D


@export var damage := 1


func _on_area_entered(area: Area2D) -> void:
	if area is FlyingObject:
		return

	if area is Mothership:
		deal_damage(area)
	queue_free()


func deal_damage(mothership: Mothership) -> void:
	mothership.hp -= damage
