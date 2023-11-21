extends AnimatedSprite2D

@export var type = "progression"
@export var value := 1

func _ready():
	pass 



func _process(delta):
	for x in $Area2D.get_overlapping_bodies():
		if x.name == "Mika":
			if type == "progression":
				x.sfx("pickup")
				if global.gamesave.progression < value: global.gamesave.progression = value
				destroy()

func destroy():
	queue_free()
