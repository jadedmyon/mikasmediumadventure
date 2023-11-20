extends Sprite2D



func _ready():
	pass # Replace with function body.



func _process(delta):
	var mika = get_parent().get_parent()
	#visible = false0
	if (mika.invulntimer > 0 and mika.invulntimer % 4 == 0):
		visible = true
	else:
		visible = false
