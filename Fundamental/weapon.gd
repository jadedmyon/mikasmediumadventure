extends AnimatedSprite2D



func _ready():
	process_priority = 20



func _process(delta):
	if get_parent().direction == -1:
		if scale.x < 0:
			scale.x *= -1
			position.x *= -1
			rotation_degrees = 90 + -1*(rotation_degrees-90)
	else:
		if scale.x > 0:
			scale.x *= -1
			position.x *= -1
			rotation_degrees = 90 + -1*(rotation_degrees-90)
