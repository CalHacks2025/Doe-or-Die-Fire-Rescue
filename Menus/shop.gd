extends Control

@onready var money_field = $MoneyField 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.money:
		money_field.text = "$ %0d" % GameManager.money


func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/GameOver.tscn") # change to next level
	
	
# todo: add methods for button presses (item selection)
# todo: coin/price
