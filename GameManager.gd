extends Node

var game_over = 0 # 0, -1 lost, 1 won
var animals_saved = 0

#gamestate variables
var money = 0 # ur broke 
var TIMEOUT = 30 # default timeout for now
var timer = Timer.new() 

# stats/powerups
var PLAYER_SPEED
var WATER_RADIUS
var FIREMAN_TOTALHP
var PICKUP_RADIUS
var ANIMALRESCUE_TOTALHP

# shop prices // to do
var SPEED_PRICE = 10
var HP_PRICE = 10
var WATERRANGE_PRICE = 10
var PICKUPRANGE_PRICE = 10

# fireman stats
var player_speed = 300
var player_totalHP = 100
var water_radius = 0 # todo make it work
var pickup_radius = 0 # todo make it work
var animalRescue_totalHP = 0 # todo make it work

# per level
var last_money_earned = 0

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

func next_level():
	last_money_earned = int(timer.time_left)
	add_money(last_money_earned)
	
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
		
		
# ============= powerup functions : change values
func buy_speed():
	if spend_money(SPEED_PRICE):
		print("Speed bought")
		player_speed *= 1.1
	
func buy_hp():
	if spend_money(HP_PRICE):
		print("hp bought")
		player_totalHP *= 1.1
		animalRescue_totalHP += 1

func buy_waterRange():
	if spend_money(WATERRANGE_PRICE):
		print("water range bought")
		water_radius += 1
	
func buy_pickupRange():
	if spend_money(PICKUPRANGE_PRICE):
		print("pickup range bought")
		pickup_radius += 1

		
func _on_timer_timeout():
	print("timed out: game lost")
	last_money_earned = 0
	game_over = -1
	get_tree().change_scene_to_file("res://Menus/GameOver.tscn")
