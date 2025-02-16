extends CharacterBody2D

var health = GameManager.player_totalHP
var SPEED = GameManager.player_speed
var player_alive = true
var fire_in_range = false
var drop_in_range = false

var deers_in_range = []
var deer_in_hand = false

var anime = ""
var aScale = -1



func _ready():
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
	if body.name == "deer_hb":
		deers_in_range.append(body.get_parent())
	if body.name == "DeerDropOff":
		drop_in_range = true
	
func _on_pickup_exited(body):
	if body.name == "deer_hb":
		deers_in_range.erase(body.get_parent())
	
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
	move()
	if(velocity.x == 0 and velocity.y == 0):
		anime.play("idle_forwards")
		
	if Input.is_action_just_pressed("pickup_deer"):
		var mini_dis = 999999
		if deers_in_range and not deer_in_hand:
			var min_deer = self
			for deer in deers_in_range:
				var dist = self.position.distance_to(deer.position)
				if dist <= mini_dis:
					mini_dis = dist
					min_deer = deer
			min_deer.queue_free()
			deer_in_hand = true
	if Input.is_action_just_pressed("pickup_deer") and deer_in_hand and drop_in_range:
		deer_in_hand = false
		GameManager.animals_saved += 1
		
	
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
