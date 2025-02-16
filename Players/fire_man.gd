extends CharacterBody2D

var speed = GameManager.player_speed
var health = GameManager.player_totalHP

var anime =""
var aScale = -1
var watering = false
var lastLeft = false

var water_level = 10
var fire_objects = [] 
var water_next_to = 0

var player_alive = true

var fire_in_range = false
var fire_damage_cooldown = true

var hpBar = ""
var hScale = -1
func _ready():
	hpBar = $"GreenHp"
	hScale = hpBar.scale.x
	
	anime = $"AnimatedSprite2D"
	aScale = anime.scale.x
	anime.play("idle_forwards")
	
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
	
	print(speed)
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
	
	if Input.is_action_pressed("move_down_s"):
		anime.play("walk_forward")
		direction.y = 1
	elif  Input.is_action_pressed("move_up_w"):
		anime.play("walk_backwards")
		direction.y = -1
	
	if Input.is_action_pressed("move_left_a"):
		if direction.y == 0:
			anime.play("walk_sideways")
			if anime.scale.x > 0:
				anime.scale.x = -aScale
		lastLeft = true
		direction.x = -1
	elif  Input.is_action_pressed("move_right_d"):
		if direction.y == 0:
			anime.play("walk_sideways")
			if anime.scale.x < 0:
				anime.scale.x = aScale
		lastLeft = false
		direction.x = 1		
	
	if direction.x != 0 and direction.y != 0:
		if direction.y == -1:
			anime.play("walk_backwards")
		else:
			anime.play("walk_forward")
			
		direction = direction.normalized()
	
	velocity = direction * speed
	move_and_slide()

func _on_fire_man_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("fire"):
		fire_in_range = true

func _process(delta: float) -> void:
	if not watering:
		move()
		if(velocity.x == 0 and velocity.y == 0):
			anime.play("idle_forwards")
	
	var pHealth = float(health) / float(GameManager.player_totalHP)
	hpBar.scale.x = hScale * pHealth
	
	
	if water_next_to > 0 and Input.is_action_just_pressed("refill_water"):
		water_level = 10
	elif Input.is_action_just_pressed("refill_water") and water_level > 0:
		var fire_died = false
		for fire in fire_objects:
			fire.queue_free()
			fire_died = true
		fire_objects.clear() 
		
		if fire_died:
			watering = true
			anime.play("watering")
			if not lastLeft:
				anime.scale.x = -aScale
			else:
				anime.scale.x = aScale	
			await anime.animation_finished
			watering = false
			water_level = 0			
	
	fire_damage()
	
	if health <= 0:
		player_alive = false
		GameManager.fire_man_alive = false
		health = 0
		self.queue_free()




	
