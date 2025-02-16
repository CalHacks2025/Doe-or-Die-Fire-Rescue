extends Camera2D

@export var characters_group_name: String = "players"  # Group name for characters

func _process(delta):
	var characters = get_tree().get_nodes_in_group(characters_group_name)

	if characters.size() == 2:
		# Both characters are alive, follow the midpoint
		global_position = (characters[0].global_position + characters[1].global_position) / 2
	elif characters.size() == 1:
		# Only one character is alive, follow the single character
		global_position = characters[0].global_position
