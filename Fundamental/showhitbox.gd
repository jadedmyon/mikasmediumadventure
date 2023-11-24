extends Sprite2D




func _ready():
	self_modulate = Color(4.1,0.7,0.3,0.7)



func _process(delta):
	var mika = get_parent().get_parent()
	
	
	if mika.invulntimer != 0:
		visible = false
	else:
		visible = true
	
	if mika.inputheld("down"):
		refresh()


	modulate.a -= 0.01

func refresh():
	self.modulate.a = 2.0
