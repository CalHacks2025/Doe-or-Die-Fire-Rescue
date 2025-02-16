extends CharacterBody2D

@export var fireman : CharacterBody2D # The fireman, for chasing and collision
@export var hit_radius: float = 200.0  # Radius to detect the player
@export var random_move_interval: float = 2.0  # Time between random direction changes

# Init random stuff to 0 for now
var random_direction: Vector2 = Vector2.ZERO
var random_move_timer: float = 0.0

const SPEED = 175
var is_chasing: bool = false

func get_random_direction() -> Vector2:
	# Generate a random direction vector
	var angle = randf_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)).normalized()

func _ready():
	fireman = get_tree().get_nodes_in_group("fire_man")[0] # Set fireman entity to chase
	#$AnimatedSprite2D.play("idle")
	
	# Setup area for aggro (chasing behaviour) towards fireman
	var da = $"deer_agro"
	da.area_entered.connect(_on_aggro_entered)
	
	var dna = $"deer_deagro"
	dna.area_exited.connect(_on_aggro_exited)
	
	# Initialize random movement
	#random_direction = get_random_direction()
	#random_move_timer = random_move_interval

func _on_aggro_entered(body):
	if body.name == "fire_man_hitbox":
		is_chasing = true

func _on_aggro_exited(body):
	if body.name == "fire_man_hitbox":
		is_chasing = false

# Head towards fireman if aggroed
func chase_fireman() -> void:
	velocity = Vector2.ZERO
	if fireman:
		# Calculate direction to the player and move
		velocity = position.direction_to(fireman.position) * SPEED
		move_and_slide()
		$AnimatedSprite2D.play("walking")

# Head in a pseudo random fashion
func move_random() -> void:
	velocity = Vector2.ZERO
	pass
	

#func _on_DetectRadius_body_entered(body):
	## Damage if a fireman
	#if body == fireman:
		#fireman.take_damage(10)
#
## Distance the animal away from fireman to avoid recollision
#func _on_DetectRadius_body_exited(body):
	#if body == fireman:
		#velocity = -position.direction_to(fireman.position) * 1/10 * SPEED
		#move_and_slide()

func _process(_delta):
	# Check if fireman in range -- chase or move randomly
	if is_chasing:
		chase_fireman()
	else:
		move_random()
