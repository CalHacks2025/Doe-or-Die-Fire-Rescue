extends CharacterBody2D

var health = GameManager.player_totalHP
var SPEED = GameManager.player_speed
var player_alive = true
var iframe_cooldown = true # false when iframes active
var fire_in_range = false
var drop_in_range = false

var animals_in_range = []
var deer_in_hand = false
var bunny_in_hand = false

var anime = ""
var aScale = -1

var hpBar = ""
var hScale = -1


func _ready():
	hpBar = $"GreenHp"
	hScale = hpBar.scale.x
	
	var animal_rescute_hitbox = $"animal_rescue_hitbox"
	animal_rescute_hitbox.area_entered.connect(_on_body_entered)  # Correct in Godot 4
	animal_rescute_hitbox.area_exited.connect(_on_body_exited)
	
	var pickup = $"pickup_range"
	pickup.area_entered.connect(_on_pickup_entered)
	pickup.area_exited.connect(_on_pickup_exited)
	
	anime = $"AnimatedSprite2D"
	aScale = anime.scale.x
	anime.play("idle_forwards")
	

func _on_pickup_entered(body):
	if body.name == "deer_hb" or body.name == "bunny_hb":
		animals_in_range.append(body.get_parent())
	if body.name == "DeerDropOff":
		drop_in_range = true
	
func _on_pickup_exited(body):
	if body.name == "deer_hb" or body.name == "bunny_hb":
		animals_in_range.erase(body.get_parent())
	
	if body.name == "DeerDropOff":
		drop_in_range = false

func move() -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_down_da"):
		anime.play("walk_forwards")
		direction.y = 1
	elif  Input.is_action_pressed("move_up_ua"):
		anime.play("walk_backwards")
		direction.y = -1
	
	if Input.is_action_pressed("move_left_la"):
		if direction.y == 0:
			anime.play("walk_sideways")
			if anime.scale.x > 0:
				anime.scale.x = -aScale
		direction.x = -1
	elif  Input.is_action_pressed("move_right_ra"):
		if direction.y == 0:
			anime.play("walk_sideways")
			if anime.scale.x < 0:
				anime.scale.x = aScale
		direction.x = 1
	
	
	if direction.x != 0 and direction.y != 0:
		direction = direction.normalized()
	
	velocity = direction * SPEED
	move_and_slide()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	
	var pHealth = float(health) / float(GameManager.player_totalHP)
	hpBar.scale.x = hScale * pHealth
	
	move()
	if(velocity.x == 0 and velocity.y == 0):
		anime.play("idle_forwards")
		
	if Input.is_action_just_pressed("pickup_deer"):
		var mini_dis = 999999
		if animals_in_range and not deer_in_hand and not bunny_in_hand:
			var min_animal = self
			for deer in animals_in_range:
				var dist = self.position.distance_to(deer.position)
				if dist <= mini_dis:
					mini_dis = dist
					min_animal = deer
			if "Deer" in min_animal.name :
				deer_in_hand = true
			else:
				bunny_in_hand = true
			min_animal.queue_free()
			
	if Input.is_action_just_pressed("pickup_deer") and (deer_in_hand or bunny_in_hand) and drop_in_range:
		if bunny_in_hand:
			bunny_in_hand = false
		else:
			deer_in_hand = false
		GameManager.animals_saved += 1
		
	
	fire_kill()
	if health <=0:
		player_alive = false
		GameManager.animal_rescute_alive = false
		health = 0
		print("Player has been killed")
		self.queue_free()

func _on_damage_cooldown_timeout() -> void:
	iframe_cooldown = true

func take_damage(amount: int):
	health -= amount
	iframe_cooldown = false
	$damage_cooldown.start()

func fire_kill():
	if fire_in_range and iframe_cooldown == true:
		take_damage(35)

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
