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

		##This is a massive mess I should have just given Debut Mika a different script for flashing
		##I will do so for other bosses but until then, too bad!
	if mika.state == "ninebutton":
		modulate = Color(1,0.6,0.7,1)
	elif mika.vulnerable and mika.frame % 4 == 0 and mika.invulntimer == 0:
		visible = true 
		modulate = Color(1,0.3,0.2,1)
	elif mika.state == "reveal":
		visible = true
		modulate = Color ( 5 - float (frame) / 30 , 1, 1, 1 )
	
	else: modulate = defaultmodulate
