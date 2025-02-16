extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	print("Start button pressed")
	get_tree().change_scene_to_file("res://world.tscn") # Change to Level 1


func _on_exit_pressed() -> void:
	print("Exit button pressed in main menu")
	get_tree().quit()
