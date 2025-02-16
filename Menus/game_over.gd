extends Control

@onready var label = $Label
@onready var factLabel = $FactLabel

var facts = ["The average number of people exposed to heatwaves has increased by approximately 125 million since the beginning of the century.
", "These broader climate changes include: rising sea levels, shrinking mountain glaciers, accelerating ice melt in Greenland, Antarctica and the Arctic, and shifts in flower and plant blooming times.", 
"Human activity, especially greenhouse gas emissions, is considered the dominant cause of temperature increases.", 
"The greenhouse effect refers to the way the Earth’s atmosphere traps and absorbs solar energy.", 
"In 2018, there were 14 extreme-weather events that resulted in more than $1 billion in damages."]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var random_fact = facts.pick_random()
	factLabel.text = random_fact
	
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
	print("HELLO WORLD")
	get_tree().change_scene_to_file("res://Menus/Shop.tscn") # Change to level 1


func _on_exit_pressed() -> void:
	get_tree().quit()
