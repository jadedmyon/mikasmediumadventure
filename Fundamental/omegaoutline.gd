extends AnimatedSprite2D
var actionframe := 0


func _ready():
	process_priority = 10000


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	actionframe +=1 
	
	var actualsprite := get_parent().get_node("sprite")
	animation = actualsprite.animation
	frame = actualsprite.frame
	offset = actualsprite.offset
	scale.x = get_parent().realscale * get_parent().direction * 1.1
	scale.y = get_parent().realscale * 1.1
	
	position.x = get_parent().direction * 5
	
	if actionframe % 2 == 0:
		position.y = -96
	if actionframe % 4 == 0:
		position.y = -104
