extends CharacterBody2D

@export var fireman : CharacterBody2D # The fireman, for collision
@export var hit_radius: float = 200.0  # Radius to detect the player
@export var random_move_interval: float = 2.0  # Time between random direction changes
@onready var random_move_timer: Timer = $MovementClock

# Init random stuff to 0 for now
var random_direction: Vector2 = Vector2.ZERO

var is_moving: bool = false

const SPEED = 250 # go fast

func get_random_direction() -> Vector2:
	# Generate a random direction vector
	var angle = randf_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)).normalized()

# Handle random movement when the timer times out
func _on_random_move_timer_timeout():
	# Generate a random direction
	random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	# Reset the timer with a random interval
	random_move_timer.wait_time = randf_range(0.35, 1.25)  # Random interval between 0.35 - 1.25s
	random_move_timer.start()
	# How to properly set it to have moving animation only when moving? 
	if random_move_timer.wait_time < 0.05:
		is_moving = false
	else:
		is_moving = true

func _ready():
	fireman = get_tree().get_nodes_in_group("fire_man")[0] # Set fireman entity to damage
	
	# Initialize random movement
	random_move_timer.wait_time = random_move_interval
	random_move_timer.timeout.connect(_on_random_move_timer_timeout)
	random_move_timer.start()


# Move pseudo randomly in the generated direction
func move_randomly() -> void:
	velocity = random_direction * SPEED
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
		
	move_and_slide()

func _on_DetectRadius_body_entered(body):
	# Damage if a fireman
	if body == fireman:
		fireman.take_damage(10)

func _physics_process(_delta):
	move_randomly()
	if is_moving:
		$AnimatedSprite2D.play("moving")
	else:
		$AnimatedSprite2D.play("idle")
