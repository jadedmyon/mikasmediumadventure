extends Label

var fadespeed = 0.02

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= 1.2
	modulate.a -= fadespeed
	if modulate.a <= 0:
		print ("fdhgbsdlkfgj")
		queue_free()
