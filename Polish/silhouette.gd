extends Sprite2D



func _ready():
	pass



func _process(delta):
	modulate.a -= 0.04
	if modulate.a <= 0:
		queue_free()
