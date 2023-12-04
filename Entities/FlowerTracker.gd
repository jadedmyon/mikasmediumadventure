extends "res://Fundamental/Entity.gd"


func _ready():
	fallaccel = 12
	updateanimation = false
	vulnerable = true
	modulate = Color(0.9,1,1.5,0.9)
	



func uniquebehavior():
	
	$glow.modulate.a -= 0.005
	
	
	
	
	

	
	
	
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
			$glow.modulate.a -= 0.004
			if frame == 20:
				shoot()
			if frame == 35:
				shoot()
			if frame == 50:
				shoot()
			if frame == 65:
				shoot()
			if frame == 120:
				nstate("stand")

		"windup": #unused?
			if frame == 15:
				nstate("shoot")
		"hitstun":
			if frame == 1:
				velocity.y = - 400
				velocity.x = -110 * direction
				fallaccel = 40
			if frame == 50:
				nstate("stand")


func shoot():
	$glow.modulate.a = 1
	create_delayedhitbox()
	

