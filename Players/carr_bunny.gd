extends AnimatedSprite2D

var anime = ""
var aScale = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	aScale = scale.x
	play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var parent = get_parent()
	if parent.bunny_in_hand:
		self.modulate.a8 = 255
	else:
		self.modulate.a8 = 0
	
	if parent.anime.scale.x < 0:
		scale.x = aScale
	else:
		scale.x = -aScale
