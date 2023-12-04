extends "res://Fundamental/Entity.gd"


func _ready():
	fallaccel = 12
	updateanimation = false
	vulnerable = true
	


func uniquebehavior():
	match state:
		"stand":
			if frame == 1:
				velocity.x = 0 
			if mikadetected:
				direction = mikadirection
				var rng := randi() % 3
				if rng == 0:
					nstate("smalljump")
				else:
					nstate("shoot")
			
		"smalljump":
			if frame == 5:
				sfx("jumpsmall")
				fallaccel = 10
				
				velocity.y = - 150
				velocity.x = direction * 150
			if frame >= 10 and is_on_floor():
				nstate("shoot")
				momentumreset(300)
		"shoot":
			if frame == 20:
				shoot()
				
			if frame == 25:
				shoot()
			if frame == 38:
				shoot()
			if frame == 45:
				shoot()
			if frame == 95:
				nstate("stand")

		"windup": #unused?
			if frame == 15:
				nstate("shoot")
		"hitstun":
			if frame == 1:
				velocity.y = - 400
				velocity.x = -110 * direction
				fallaccel = 40
			if frame == 40:
				nstate("stand")


func shoot():
	sfx("bunnyshot")
	create_hitbox({ #straight
		hitboxtype = "projectile", duration = 600,
		animation = "green", offset = Vector2(0,-70), scale = Vector2(2,2),
		adjustanglevisual = "onstart",
		speedX = 10, speedY = 0, fallaccel = 0,
		
	})
	create_hitbox({ #gay
		hitboxtype = "projectile", duration = 600,
		speedX = 8.5, speedY = -5, fallaccel = 0.02,
		adjustanglevisual = "onstart",
		animation = "green", offset = Vector2(0,-51), scale = Vector2(1.5,1.5),
	})

	


