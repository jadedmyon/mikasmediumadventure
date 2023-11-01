extends Sprite2D

@export var scenename:String = "testvn"
#touch means you only need to collide with it. The object deletes itself after use. 
#pressup means collide and press up on kb. should show a UI thing showing the bound up button
@export var triggertype:String = "touch"


func _ready():
	visible = false



func _process(delta):
	for x in $Area2D.get_overlapping_bodies():
		if x.name == "Mika":
			if triggertype == "touch":
				get_parent().get_parent().createvn(scenename)
				queue_free()
