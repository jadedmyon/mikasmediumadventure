extends Node2D


var scrollspeed = 5

func _ready():
	pass 



func _process(delta):
	for x in get_children():
		x.position -= scrollspeed
		if Input.is_action_pressed("B"):
			x.position -= scrollspeed #double speed
