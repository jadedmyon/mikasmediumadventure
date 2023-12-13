extends Sprite2D

@export var levelname:String = "testlevel"
@export var posid:int = 0

func _ready():
	visible = false



func _process(delta):
	for x in $Area2D.get_overlapping_bodies():
		if x.name == "Mika":
			var gameplaynode = x.get_parent().get_parent()
			gameplaynode.levelswitch(levelname,posid)
