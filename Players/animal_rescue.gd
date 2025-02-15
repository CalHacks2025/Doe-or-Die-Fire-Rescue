extends CharacterBody2D


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

func _physics_process(delta: float) -> void:
	move()
	move_and_slide()
