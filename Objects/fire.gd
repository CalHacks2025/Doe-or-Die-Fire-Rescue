extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var spawn_timer = $Timer  # Reference to the Timer node

const MIN_TIME = 7
const MAX_TIME = 10
const SPAWN_RADIUS = 150  # Distance to spawn new fire
const MIN_SPACING = 50    # Minimum spacing to prevent overlap
const GROUP_NAME = "fire_spread"  # Group for tracking fires

func _ready() -> void:
	if GameManager.fires_left < 0:
		GameManager.fires_left = 0
	GameManager.fires_left += 1
	sprite.play("active")
	add_to_group(GROUP_NAME)  # Track this instance as fire
	start_spawn_timer()  # Begin the spreading cycle
	add_to_group("fire")

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

	# Get all TileMapLayers in the scene
	var tilemap_layers = get_tree().get_nodes_in_group("flammable")

	if tilemap_layers.is_empty():
		print("❌ No TileMapLayer found in 'flammable' group!")
		return

	# Try up to 10 times to find a valid position
	var tries = 10
	while tries > 0:
		var offset = Vector2(randf_range(-SPAWN_RADIUS, SPAWN_RADIUS), randf_range(-SPAWN_RADIUS, SPAWN_RADIUS))
		var new_position = self.position + offset
		var valid_position = false

		# Check each TileMapLayer for a flammable tile at this position
		for layer in tilemap_layers:
			var tile_coords = layer.local_to_map(new_position)
			var tile_source = layer.get_cell_source_id(tile_coords)

			# Debugging output
			print("🔎 Checking Tile:", tile_coords, " in Layer:", layer.name, "| Source ID:", tile_source)

			if tile_source != -1:  # Found a flammable tile
				# Snap the fire to the tile grid
				new_fire.position = layer.map_to_local(tile_coords)  # Use map_to_local to ensure proper alignment
				valid_position = true
				break  # Stop checking once we find a valid tile

		if valid_position:
			get_parent().add_child(new_fire)  # Add new fire to scene
			print("🔥 Fire spawned at:", new_fire.position)
			return  # Stop after successful placement

		tries -= 1

	print("⚠️ No valid fire position found.")
