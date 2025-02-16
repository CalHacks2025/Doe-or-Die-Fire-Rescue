extends CharacterBody2D

var health = 100
var player_alive = true

var fire_in_range = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func move() -> void:
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_left_la"):
		direction.x = -1
	elif  Input.is_action_pressed("move_right_ra"):
		direction.x = 1
	
	if Input.is_action_pressed("move_down_da"):
		direction.y = 1
	elif  Input.is_action_pressed("move_up_ua"):
		direction.y = -1
	
	if direction.x != 0 and direction.y != 0:
		direction = direction.normalized()
	
	velocity = direction * SPEED
	move_and_slide()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	move()
	fire_kill()
	if health <=0:
		player_alive = false
		health = 0
		print("Player has been killed")
		self.queue_free()

		
func fire_kill():
	if fire_in_range:
		health = 0
		print("player died")

func _ready():
	var area2D = $"animal_rescue_hitbox"
	area2D.area_entered.connect(_on_body_entered)  # Correct in Godot 4
	area2D.area_exited.connect(_on_body_exited)
	
func _on_body_entered(body):
	if body.name =="Fire_Hurtbox":
		fire_in_range = true

func _on_body_exited(body: Node):
	if body.name == "Fire_Hurtbox":
		fire_in_range = false

func _on_animal_rescue_hitbox_body_entered(body: Node2D) -> void:
	print("Entered:", body.name)
	if body.has_method("fire"):
		print("Fire detected!")
		fire_in_range = true
func _on_animal_rescue_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("fire"):
		fire_in_range = false
