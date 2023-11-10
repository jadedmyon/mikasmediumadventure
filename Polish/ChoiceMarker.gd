extends Sprite2D

var dialoguepos := 0




func _process(delta):
	
	if get_parent().dialogueoptions == []:
		queue_free()
	
	if get_parent().dialogueselected == dialoguepos:
		self_modulate = Color(4,1,0.3,1)
		$behind.visible = true
	else:
		self_modulate = Color(1,1,1,1)
		$behind.visible = false
