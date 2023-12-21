extends Node2D


var scrollspeed = 2

func _ready():
	pass 



func _process(delta):
	for x in get_children(): if x.name != "CanvasLayer":
		x.position.y -= scrollspeed
		if Input.is_action_pressed("B"):
			x.position.y -= scrollspeed #double speed
		if x.name == "ender":
			if x.position.y <= -40:
				get_tree().change_scene_to_file("res://Fundamental/Meta.tscn")
