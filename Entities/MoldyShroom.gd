extends "res://Fundamental/Entity.gd"

func _ready():
	hp = 30
	realscale = 2
	displayname = "Moldy Shroom" 





func uniquebehavior():
	match state:
		"stand":
			if frame == 1:
				dustoomf(Vector2(0,-20))
				sfx("shotgoofy")
				create_hitbox({hitboxtype = "projectile",damage = 10, speedscale = 0.5, duration = 100, animation = "spore", offset = Vector2(0,-50),speedY = -24,fallaccel = 1,speedX = 3})

				#FARTHER



			if frame == 4:
				sfx("shotgoofy")
				create_hitbox({hitboxtype = "projectile",damage = 10, speedscale = 0.5, duration = 100, animation = "spore", offset = Vector2(0,-50),speedY = -24,fallaccel = 1,speedX = -3})
			if frame == 8:
				sfx("shotgoofy")
				create_hitbox({hitboxtype = "projectile",damage = 10, speedscale = 0.5, duration = 100, animation = "spore", offset = Vector2(0,-50),speedY = -24,fallaccel = 1,speedX = 6})
			if frame == 12:
				sfx("shotgoofy")
				create_hitbox({hitboxtype = "projectile",damage = 10, speedscale = 0.5, duration = 100, animation = "spore", offset = Vector2(0,-50),speedY = -24,fallaccel = 1,speedX = -6})
			if frame == 105:
				nstate("prepare")
		"prepare":
			if frame == 11:
				nstate("stand")



func dustoomf(newpos:Vector2=Vector2(0,0)):
	var dustoomf = preload("res://Entities/DustOomf.tscn").instantiate()
	dustoomf.position = position + newpos
	dustoomf.modulate = Color(1,1.1,1.5,0.3)
	dustoomf.scale *= 0.7
	
	get_parent().add_child(dustoomf)
