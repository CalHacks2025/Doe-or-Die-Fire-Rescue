extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var curr_hp: int = 3
var is_invincible: bool = false
var iframe_duration: float = 0.5

func die():
	# Respawn
	
	queue_free()

func take_damage(amount : int):
	if is_invincible:
		return
		
	curr_hp -= amount
	if curr_hp <= 0:
		die()
	else:
		is_invincible = true
		await get_tree().create_timer(iframe_duration).timeout

func move() -> void:
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_left_a"):
		direction.x = -1
	elif  Input.is_action_pressed("move_right_d"):
		direction.x = 1
	
	if Input.is_action_pressed("move_down_s"):
		direction.y = 1
	elif  Input.is_action_pressed("move_up_w"):
		direction.y = -1
	
	if direction.x != 0 and direction.y != 0:
		direction = direction.normalized()
	
	velocity = direction * SPEED

func _physics_process(delta: float) -> void:
	
	move()

	move_and_slide()
