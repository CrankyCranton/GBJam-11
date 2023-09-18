class_name TutorialLevel extends Level


var tutorial_index := 0
var astroid: Obstacle = null

@onready var text_box: TextBox = %TextBox
@onready var spawner: Spawner = $Spawner
@onready var hook_trigger: RayCast2D = %HookTrigger


func _ready() -> void:
	spawner.set_process(false)
	text_box.print_text("DPad to move.")


func _physics_process(delta: float) -> void:
	super(delta)
	if hook_trigger.is_colliding() and hook_trigger.get_collider() is Trash:
		text_box.print_text("Press B to collect trash.", "b")
		hook_trigger.enabled = false



func _on_text_box_finished() -> void:
	tutorial_index += 1
	match tutorial_index:
		1:
			await ship.moved_both_ways
			await get_tree().create_timer(2.0).timeout
			text_box.print_text("Your galactic garbage truck is below.",
					"start", Control.PRESET_TOP_WIDE)
		2:
			spawner.spawn(preload("res://scenes/trash.tscn"))
			await get_tree().create_timer(1.5).timeout
			hook_trigger.enabled = true
		3:
			await get_tree().create_timer(1.5).timeout
			text_box.print_text("Beware: Grabbing stuff besides trash is like grabbing a porcipine.")
		4:
			astroid = spawner.spawn(preload("res://scenes/obstacle.tscn"))
			await get_tree().create_timer(1.0).timeout
			text_box.print_text("An astroid! Don't let it hit your garbage truck.")
		5:
			text_box.print_text("Press A to shoot it down.")
		6:
			await astroid.destroyed
			await get_tree().create_timer(1.0).timeout
			text_box.print_text("Goal: Collect as much trash as possible!")
		7:
			spawner.set_process(true)
