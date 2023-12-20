extends "res://Fundamental/Entity.gd"


func _ready():
	displayname = "Mika"
	fallaccel = 19

	realscale = 0.25
	hp = 1
	updateanimation = false


func uniquebehavior():
	match state:
		"stand":
			momentumreset(60)
			if mikadetected and frame > 40:
				direction = mikadirection * -1
				nstate("dash")

		"dash":
			if frame > 1:
				xvelocity_towards(direction*-80,1000)
			if frame == 2:
				create_hitbox({damage = 6, duration = 499, scale = Vector2(3.2,4), offset = Vector2(0,-50)})
			if frame == 70:
				nstate("stand")


func dustoomf():
	var dustoomf = preload("res://Entities/DustOomf.tscn").instantiate()
	dustoomf.position = position
	get_parent().add_child(dustoomf)
