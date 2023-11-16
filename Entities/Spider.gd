extends "res://Fundamental/Entity.gd"


func _ready():
	fallaccel = 0

func _physics_process(delta):
	tickframe()
	if hitstop == 0:
		if invulntimer > 0: invulntimer-=1
		move_and_slide()
		gravity()
		update_animation()
		detect_mika()
		state_called = []
		match state:
			"stand":
				if mikadetected:
					nstate("climb")
			
			"climb":
				if frame == 1:
					var rng:= randi() % 4
					if rng in [0,1]:
						velocity.y = 120
					if rng in [1,2]:
						velocity.x = mikadirection * 150
					if rng in [2,3]:
						
						if findmika().position.y - position.y > 500 :
							print ("too high up!!!")
							velocity.y = 120
						else:
							velocity.y = -120
						
				
				
				if frame == 25:
					velocity = Vector2(0,0)
				
				if frame == 55:
					nstate("shoot")
				
			"shoot":
				if frame == 1:
					create_hitbox({hitboxtype = "projectile", animation = "spider", 
					velocitytowardmika = 13, speedX = 0, speedY = 0, duration = 2100, speedscale = 0.5, })
					create_hitbox({hitboxtype = "projectile", animation = "spider", 
					velocitytowardmika = 12, speedX = 0, speedY = 0, duration = 2100, speedscale = 0.5, anglevelocity = 1, angle =15})
					create_hitbox({hitboxtype = "projectile", animation = "spider", 
					velocitytowardmika = 12, speedX = 0, speedY = 0, duration = 2100, speedscale = 0.5, anglevelocity = 1, angle = -15 })
				if frame == 40:
					nstate("stand")



func findmika() -> Node:
	for x in get_parent().get_children():
		if x.name == "Mika":
			return x
	return null
#for a harder version of this enemy?
func interestingshoot():
	create_hitbox({hitboxtype = "projectile", animation = "spider", 
					velocitytowardmika = 9, speedX = 0, speedY = 0, duration = 2100, speedscale = 0.5, })
	create_hitbox({hitboxtype = "projectile", animation = "spider", 
					velocitytowardmika = 9, speedX = 0, speedY = 0, duration = 2100, speedscale = 0.5, anglevelocity = 5, angle = 5 })
	create_hitbox({hitboxtype = "projectile", animation = "spider", 
					velocitytowardmika = 9, speedX = 0, speedY = 0, duration = 2100, speedscale = 0.5, anglevelocity = 5, angle = -5 })				
