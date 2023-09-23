class_name Trash extends FlyingObject


const TRASH_SPRITES := [
	preload("res://assets/trash/engine_trash.png"),
	preload("res://assets/trash/panel.png"),
	preload("res://assets/trash/RandomPiece1.png"),
	preload("res://assets/trash/regular_trash_1.png"),
	preload("res://assets/trash/regular_trash_2.png"),
	preload("res://assets/trash/wing_trash_left.png"),
	preload("res://assets/trash/wing_trash_right.png"),
]

@export var value := 1
@export var health_value := 1

var collected := false

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	super()
	load_sprite()


func load_sprite() -> void:
	sprite.texture = TRASH_SPRITES.pick_random()


func deal_damage(mothership: Mothership) -> void:
	if collected:
		mothership.trash += value
		mothership.hp += health_value
	else:
		super(mothership)


func _on_area_entered(area: Area2D) -> void:
	if collected:
		if area is Mothership:
			destroy(area)
			if hp <= 0:
				destroyed.emit(true)
	else:
		super(area)
		if hp <= 0:
			destroyed.emit(false)
