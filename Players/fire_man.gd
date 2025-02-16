extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FIRE_DIS = 70

var water_level = 10
var fire_objects = [] 
var water_next_to = 0

var health = 100
var player_alive = true

var fire_in_range = false
var fire_damage_cooldown = true

func _ready():
	add_to_group("fire_man")
	var fmhb = $"fire_man_hitbox"
	fmhb.area_entered.connect(_on_body_entered)  
	fmhb.area_exited.connect(_on_body_exited)
	
	var br = $"bucket_range"
	br.area_entered.connect(_on_bucket_entered)
	br.area_exited.connect(_on_bucket_exited)
	
	var wr = $"water_range"
	wr.area_entered.connect(_on_water_entered)
	wr.area_exited.connect(_on_water_exited)
func _on_water_entered(body):
	if body.name == "water_hit_box":
		water_next_to += 1

func _on_water_exited(body):
	if body.name == "water_hit_box":
		water_next_to -= 1
		
func _on_bucket_entered(body):
	if body.name == "Fire_Hurtbox":
		fire_objects.append(body.get_parent())

func _on_bucket_exited(body):
	if body.name == "Fire_Hurtbox":
		fire_objects.erase(body.get_parent())

func _on_body_entered(body):
	if body.name =="Fire_Hurtbox":
		fire_in_range = true

func _on_body_exited(body: Node):
	if body.name == "Fire_Hurtbox":
		fire_in_range = false
	
func fire_damage():
	if fire_in_range and fire_damage_cooldown == true:
		health = health - 10
		fire_damage_cooldown = false
		$damage_cooldown.start()


func _on_damage_cooldown_timeout() -> void:
	fire_damage_cooldown = true

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

func _on_fire_man_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("fire"):
		fire_in_range = true

func _process(delta: float) -> void:
	move()
	
	if water_next_to > 0 and Input.is_action_just_pressed("refill_water"):
		water_level = 10
	elif Input.is_action_just_pressed("refill_water") and water_level > 0:
		var fire_died = false
		for fire in fire_objects:
			print(fire.position)
			fire.queue_free()
			fire_died = true
		fire_objects.clear() 
		if fire_died:
			water_level = 0			
	
	fire_damage()
	
	if health <= 0:
		player_alive = false
		health = 0
		self.queue_free()




	
