extends CharacterBody2D

@export var firefighter : CharacterBody2D

const SPEED = 25

func _physics_process(delta: float) -> void:
	if firefighter:
		# Calculate direction to the player and move
		velocity = position.direction_to(firefighter.position) * SPEED
		move_and_slide()
