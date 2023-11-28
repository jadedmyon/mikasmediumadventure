extends "res://Fundamental/Entity.gd"


func _ready():
	displayname = "idk what this thing is"
	fallaccel = 19

	realscale = 2.5
	hp = 12
	updateanimation = false


func uniquebehavior():
	match state:
		"stand":
			momentumreset(5)
			if mikadetected:
				direction = mikadirection
				nstate("windup")

		"roll":
			if frame > 1:
				xvelocity_towards(direction*30,900)
			if frame == 2:
				create_hitbox({damage = 8, duration = 499, scale = Vector2(2.5,4), offset = Vector2(0,-50)})
			if frame == 50:
				nstate("rest")

		"windup":
			if frame == 15:
				nstate("roll")
		"rest":
			momentumreset(20)
			if frame > 30:
				momentumreset(5)
			if frame == 50:
				nstate("stand")


func dustoomf():
	var dustoomf = preload("res://Entities/DustOomf.tscn").instantiate()
	dustoomf.position = position
	get_parent().add_child(dustoomf)
