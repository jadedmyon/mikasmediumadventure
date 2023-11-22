extends Sprite2D

var defaultmodulate = Color (1,1,1,1)

func _ready():
	defaultmodulate = modulate



func _process(delta):
	var mika = get_parent().get_parent()
	#visible = false0
	if (mika.invulntimer > 0 and mika.invulntimer % 4 == 0):
		visible = true
	else:
		visible = false


	if mika.state == "ninebutton":
		modulate = Color(1,0.6,0.7,1)
	else: modulate = defaultmodulate
