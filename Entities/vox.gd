class_name FuckItVoxIsAClassNow extends "res://Fundamental/Entity.gd"

func _ready():
	realscale = 0.7
	fallaccel = 0

func boot():

	state = "boot"
	create_hitbox({scale = Vector2(30,30), damage = 0, duration = 5})
