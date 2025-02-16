extends Node2D


#============== timer default code should go in each level
@onready var timer_label = $TimerLabel  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.timer_reset(30)
	GameManager.timer_start()
	print("start dummy level + start timer")
	
	connect("tree_exited", Callable(self, "_on_scene_exit"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.timer:
		var time_left = int(GameManager.timer.time_left)
		var minutes = time_left / 60
		var seconds = time_left % 60
		timer_label.text = "%02d:%02d" % [minutes, seconds]
	#pass

func _on_scene_exit():
	GameManager.next_level()
	GameManager.timer_stop()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/Shop.tscn")
