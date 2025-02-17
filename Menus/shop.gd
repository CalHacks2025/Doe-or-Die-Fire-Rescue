extends Control

@onready var money_field = $MoneyField
@onready var earned_field = $MoneyEarnedField

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.last_money_earned:
		earned_field.text = "$ %0d" % GameManager.last_money_earned
	if GameManager.money:
		money_field.text = "$ %0d" % GameManager.money


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn") # change to next level
	
	
func _on_buy_speed_pressed() -> void:
	print("buy spee")
	GameManager.buy_speed()
	money_field.text = "$ %0d" % GameManager.money


func _on_buy_hp_pressed() -> void:
	print("buy hp")
	GameManager.buy_hp()
	money_field.text = "$ %0d" % GameManager.money


func _on_buy_water_pressed() -> void:
	GameManager.buy_waterRange()


func _on_buy_pickup_pressed() -> void:
	GameManager.buy_pickupRange()
