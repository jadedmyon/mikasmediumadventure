extends Label



func _ready():
	modulate.a = 4.0



func _process(delta):
	modulate.a -= 0.01
	if modulate.a <= 0: queue_free()
