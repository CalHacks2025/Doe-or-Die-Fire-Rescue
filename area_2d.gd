extends Area2D

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body is CharacterBody2D:
		print("tutorial Complete!")
		GameManager.tutorialComplete()
		get_tree().change_scene_to_file("res://Menus/Shop.tscn") # Change level
