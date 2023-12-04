extends Sprite2D




func _ready():
	self_modulate = Color(4.1,0.7,0.3,0.7)



func _process(delta):
	var mika = get_parent().get_parent()
	
	
	if mika.invulntimer != 0:
		modulate.r = 0.5
		modulate.g = 0.7
		modulate.b = 2.5
		
	else:
		modulate.r = 1
		modulate.g = 1
		modulate.b = 1
	
	if mika.inputheld("down"):
		refresh()


	modulate.a -= 0.01

func refresh():
	self.modulate.a = 2.0
