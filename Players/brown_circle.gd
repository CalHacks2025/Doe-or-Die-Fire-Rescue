extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var parent = get_parent()
	if not parent.deer_in_hand:
		self.modulate.a8 = 75
	else:
		self.modulate.a8 = 0
