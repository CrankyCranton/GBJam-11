class_name TutorialLevel extends Level


const OBSTACLE := preload("res://scenes/obstacle.tscn")
const TRASH := preload("res://scenes/trash.tscn")

var tutorial_index := 0
var astroid: Object = null
var hit := 0

@onready var text_box: TextBox = %TextBox
@onready var hook_trigger: RayCast2D = %HookTrigger
@onready var mothership: Mothership = $Mothership


func _ready() -> void:
	mothership.immune = true
	spawner.set_process(false)
	upgrading = false
	text_box.print_text("Use DPad to move.")


func _physics_process(delta: float) -> void:
	super(delta)
	if hook_trigger.is_colliding() and hook_trigger.get_collider() is Trash:
		text_box.print_text("Press B to collect trash.", "b")
		hook_trigger.enabled = false
		hook.set_process_input(true)


func _on_mothership_died(score: int, time: int) -> void:
	super(score, time)
	Data.data.first_time = false
	Data.save_data(Data.data)


func _on_text_box_finished() -> void:
	tutorial_index += 1
	match tutorial_index:
		1:
			await ship.moved_both_ways
			await get_tree().create_timer(4.0, false).timeout
			text_box.print_text("Your galactic garbage truck is at the bottom.",
					"start", Control.PRESET_TOP_WIDE)
		2:
			await get_tree().create_timer(2.0, false).timeout
			hook.set_process_input(false)
			var trash: Trash = await spawner.spawn(TRASH)
			trash.collected = true
			await get_tree().create_timer(1.0, false).timeout
			hook_trigger.enabled = true
		3:
			await get_tree().create_timer(2.0, false).timeout
			text_box.print_text("Goal: Collect 5 trash")
			#text_box.print_text("Beware: Grabbing stuff besides trash is like grabbing a porcupine.")
		4:
			while hit < 5:
				astroid = await spawner.spawn(TRASH)
				astroid.destroyed.connect(
					func(by_player: bool):
						if by_player:
							hit += 1
				)
				await astroid.destroyed

			await get_tree().create_timer(2.0, false).timeout
			astroid = await spawner.spawn(OBSTACLE)
			await get_tree().create_timer(0.5, false).timeout
			text_box.print_text("An asteroid! Don't let it hit your garbage truck.")
		5:
			text_box.print_text("Press A to shoot it down.")
		6:
			await astroid.destroyed
			await get_tree().create_timer(2.0, false).timeout
			text_box.print_text("Goal: hit 5 metiors")
		7:
			hit = 0
			while hit < 5:
				astroid = await spawner.spawn(OBSTACLE)
				astroid.destroyed.connect(
					func(by_player: bool):
						if by_player:
							hit = hit + 1
				)
				await astroid.destroyed

			await get_tree().create_timer(4.0, false).timeout
			text_box.print_text("Now you're all set to clean the universe!")
		8:
			mothership.immune = false
			spawner.set_process(true)
			upgrading = true
