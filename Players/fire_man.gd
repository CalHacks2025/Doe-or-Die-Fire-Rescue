extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FIRE_DIS = 70

var water_level = 10
var fire_objects = []  # List to store objects and their distances
var water_next_to = 0

func _ready():
	var area2D = $Area2D
	area2D.area_entered.connect(_on_body_entered)  # Correct in Godot 4
	area2D.area_exited.connect(_on_body_exited)
	
func _on_body_entered(body):
	if body.name == "water_hit_box":
		water_next_to += 1
	elif body.name =="Fire_Hurtbox":
		print("YOUCH!")

func _on_body_exited(body: Node):
	if body.name == "water_hit_box":
		water_next_to -= 1
	
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
	move_and_slide()

func _process(delta: float) -> void:
	move()
	
	if water_next_to > 0 and Input.is_action_just_pressed("refill_water"):
		water_level = 10
	elif Input.is_action_just_pressed("refill_water") and water_level > 0:
		var fire_objects = get_tree().get_nodes_in_group("fire")
		var fire_died = false
		for fire in fire_objects:
			if(self.position.distance_to(fire.position) <= FIRE_DIS):
				fire.queue_free()
				fire_died = true
		if fire_died:
			water_level = 0			
