extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var spawn_timer = $Timer  # Reference to the Timer node

const MIN_TIME = 7
const MAX_TIME = 10
const SPAWN_RADIUS = 100  # Distance to spawn new fire
const MIN_SPACING = 50    # Minimum spacing to prevent overlap
const GROUP_NAME = "fire_spread"  # Group for tracking fires

func _ready() -> void:
	sprite.play("active")
	add_to_group(GROUP_NAME)  # Track this instance as fire
	start_spawn_timer()  # Begin the spreading cycle

func _process(delta: float) -> void:
	if sprite.animation != "active":
		sprite.play("active")

func start_spawn_timer():
	var wait_time = randf_range(MIN_TIME, MAX_TIME)
	spawn_timer.wait_time = wait_time  # Random delay before spawning
	spawn_timer.start()  # Start the timer

func _on_timer_timeout() -> void:
	if !is_duplicate_too_close():  # Ensure no overlapping fires
		spawn_fire()
	start_spawn_timer()  # Restart spreading cycle

func is_duplicate_too_close() -> bool:
	for node in get_tree().get_nodes_in_group(GROUP_NAME):
		if node != self and node.position.distance_to(self.position) < MIN_SPACING:
			return true  # Fire too close, don't spawn new one
	return false

func spawn_fire():
	var new_fire = duplicate()
	
	# Try up to 10 times to find a valid position
	var tries = 10
	while tries > 0:
		var offset = Vector2(randf_range(-SPAWN_RADIUS, SPAWN_RADIUS), randf_range(-SPAWN_RADIUS, SPAWN_RADIUS))
		var new_position = self.position + offset
		
		var too_close = false
		for node in get_tree().get_nodes_in_group(GROUP_NAME):
			if node.position.distance_to(new_position) < MIN_SPACING:
				too_close = true
				break

		if not too_close:  # If a valid spot is found, break loop
			new_fire.position = new_position
			break

		tries -= 1

	get_parent().add_child(new_fire)  # Add the new fire to the scene
