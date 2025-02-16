extends Control

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.game_over == -1:
		print("Set game over message")
		label.text = "Game Over :("
	else:
		print("Set you won message")
		label.text = "You won!"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn")

func _on_exit_button_pressed() -> void:
	print("hi")
	get_tree().quit()
