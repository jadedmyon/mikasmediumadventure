class_name FuckItVoxIsAClassNow extends "res://Fundamental/Entity.gd"

func _ready():
	realscale = 1
	fallaccel = 0

func boot():
	sfx("boot")
	state = "boot"
	create_hitbox({scale = Vector2(30,30), damage = 0, duration = 5})
