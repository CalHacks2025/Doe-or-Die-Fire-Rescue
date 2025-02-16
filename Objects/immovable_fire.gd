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
	add_to_group("fire")

func _process(delta: float) -> void:
	if sprite.animation != "active":
		sprite.play("active")
