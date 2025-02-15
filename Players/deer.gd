extends CharacterBody2D

@export var fireman : CharacterBody2D

const SPEED = 25

func _ready():
	fireman = %fire_man # Set fireman entity to chase
	$AnimatedSprite2D.play("walking")

func move() -> void:
	velocity = Vector2.ZERO
	if fireman:
		# Calculate direction to the player and move
		velocity = position.direction_to(fireman.position) * SPEED
		move_and_slide()
		# TODO Update animation direction?
func _on_DetectRadius_body_entered(body):
	# Damage if a fireman
	if body == fireman:
		fireman.take_damage(1)

# Distance the animal away from fireman to avoid recollision
func _on_DetectRadius_body_exited(body):
	if body == fireman:
		velocity = -position.direction_to(fireman.position) * SPEED
		move_and_slide()

func _physics_process(_delta):
	move()
