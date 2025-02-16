extends Node

var money = 0 # ur broke 
var TIMEOUT = 30 # default timeout for now
var timer = Timer.new() 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.wait_time = TIMEOUT
	timer.one_shot = true
	add_child(timer)
	
func timer_start():
	timer.start()
	print("Timer Started")
	#pass
	
func timer_stop():
	print ("Timer stopped. time left = %0d" % timer.time_left)
	timer.stop()
	
func timer_reset(seconds):
	print("Timer reset")
	timer.stop()
	timer.wait_time = seconds
	# you need to start it manually fool
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_money(amount):
	money += amount
	print("Money: ", money)

func spend_money(amount):
	if money >= amount:
		money -= amount
		print("Money left: ", money)
		return true
	else:
		print("Not enough money!")
		return false
		
func _on_timer_timeout():
	print("timed out")
	get_tree().change_scene_to_file("res://Menus/GameOver.tscn")
