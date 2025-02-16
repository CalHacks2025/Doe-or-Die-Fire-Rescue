#extends Area2D
#
#
#func _ready() -> void:
	#connect(_on_body_entered)
#
## Signal handler for when a body enters the area
#func _on_body_entered(body):
	#print("Body entered: ", body.name)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#var overlap = get_overlapping_bodies()
	#for body in overlap:
		#print(body.name)
