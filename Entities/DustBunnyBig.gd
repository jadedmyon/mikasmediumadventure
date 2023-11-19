extends "res://Fundamental/Entity.gd"


func _ready():
	displayname = "Dust Bunny"
	fallaccel = 12



func uniquebehavior():
	match state:
		"stand":
			if frame == 1:
				velocity.x = 0 
			if mikadetected:
				direction = mikadirection
				var rng := randi() % 4
				if rng == 0:
					nstate("smalljump")
				else:
					nstate("windup")
			
		"smalljump":
			if frame == 5:
				sfx("jumpsmall")
				fallaccel = 8

				velocity.y = - 150
				velocity.x = direction * 110
			if frame >= 10 and is_on_floor():
				nstate("stand")
				dustoomf()
		"shoot":
			if frame == 20:
				shoot()
			if frame == 30:
				shoot()
			if frame == 40:
				shoot()
			if frame == 120:
				nstate("stand")

		"windup":
			if frame == 15:
				nstate("shoot")


func shoot():
	sfx("bunnyshot")
	create_hitbox({
					hitboxtype = "projectile",damage = 8, duration = 600, 
					animation = "dustbullet", scale = Vector2(2,2),
					offset = Vector2(0,-30),fallaccel = 0.125, speedX = 8, speedY = -5,speedscale = 1,})


func dustoomf():
	var dustoomf = preload("res://Entities/DustOomf.tscn").instantiate()
	dustoomf.position = position
	dustoomf.scale *= 2
	get_parent().add_child(dustoomf)
