extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	print("Start")
	get_tree().change_scene_to_file("res://node_2d.tscn") # Change to Level 1


func _on_exit_pressed() -> void:
	print("Exit")
	get_tree().quit()
