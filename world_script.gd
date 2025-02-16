extends Node2D
@onready var timer_label = $TimerLabel  
@onready var money_label = $MoneyLabel  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.timer_reset(60)
	GameManager.timer_start()
	print("start dummy level + start timer")
	
	money_label.text = "$ %0d" % GameManager.money
	
	connect("tree_exited", Callable(self, "_on_scene_exit"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.timer:
		var time_left = int(GameManager.timer.time_left)
		var minutes = time_left / 60
		var seconds = time_left % 60
		timer_label.text = "%02d:%02d" % [minutes, seconds]


func _on_scene_exit():
	#GameManager.next_level()
	GameManager.timer_stop()
