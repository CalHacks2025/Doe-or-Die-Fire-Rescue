extends Control

@onready var money_field = $MoneyField 
@onready var earned_field = $MoneyEarnedField 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.last_money_earned:
		earned_field.text = "You earned $ %0d" % GameManager.last_money_earned


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.money:
		money_field.text = "Total moneys: $ %0d" % GameManager.money


func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/GameOver.tscn") # change to next level
	
	
func _on_buy_speed_pressed() -> void:
	GameManager.buy_speed()


func _on_buy_hp_pressed() -> void:
	GameManager.buy_hp()


func _on_buy_water_pressed() -> void:
	GameManager.buy_waterRange()


func _on_buy_pickup_pressed() -> void:
	GameManager.buy_pickupRange()
