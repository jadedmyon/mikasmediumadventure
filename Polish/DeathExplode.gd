extends AnimatedSprite2D
var actionframe := 0


func _ready():
	play()



func _process(delta):
	actionframe+=1

	if actionframe > 3:
		modulate.a -= 0.02
	if actionframe == 150:
		queue_free()
