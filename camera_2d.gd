extends Camera2D

@export var characters_group_name: String = "players"  # Group name for characters
@export var smoothing_factor: float = 0.2  # Increased smoothing factor for smoother movement
@export var follow_speed: float = 8  # Adjust the camera follow speed

func _process(delta):
	var characters = get_tree().get_nodes_in_group(characters_group_name)

	var target_position = Vector2.ZERO
	if characters.size() == 2:
		# Both characters are alive, follow the midpoint
		target_position = (characters[0].global_position + characters[1].global_position) / 2
	elif characters.size() == 1:
		# Only one character is alive, follow the single character
		target_position = characters[0].global_position
	
	# Smooth the camera's movement by following with more control over speed
	global_position = global_position.lerp(target_position, smoothing_factor * delta * follow_speed)
