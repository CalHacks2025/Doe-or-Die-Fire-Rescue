extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func fire():
	pass
	
func move() -> void:
	pass

func _physics_process(delta: float) -> void:
	move()
	move_and_slide()
