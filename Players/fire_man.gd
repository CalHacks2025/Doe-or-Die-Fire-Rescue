extends CharacterBody2D

var health = 100
var player_alive = true

var fire_in_range = false
var fire_damage_cooldown = true

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

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
	fire_damage()
	
	if health <= 0:
		player_alive = false
		health = 0
		print("Player has been killed")
		self.queue_free()


func _on_fire_man_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("fire"):
		fire_in_range = true


func _on_fire_man_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("fire"):
		fire_in_range = false
		
func fire_damage():
	if fire_in_range and fire_damage_cooldown == true:
		health = health - 10
		fire_damage_cooldown = false
		$damage_cooldown.start()
		print("player took damage")


func _on_damage_cooldown_timeout() -> void:
	fire_damage_cooldown = true
