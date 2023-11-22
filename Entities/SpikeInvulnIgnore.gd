extends "res://Fundamental/Entity.gd"
@export var launchdirection := 1

func _ready():
	fallaccel = 0
	
func uniquebehavior():
	if frame == 1:
		create_hitbox({damage=0,duration=5, scale = Vector2(3,3),
		animation = "none", invulntimer = 5, launchdirection = launchdirection})
	if frame >= 5:
		frame = 0
