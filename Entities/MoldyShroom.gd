extends "res://Fundamental/Entity.gd"

func _ready():
	hp = 30
	realscale = 2
	




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
			if frame == 1:
				dustoomf(Vector2(0,-20))
				create_hitbox({hitboxtype = "projectile",damage = 16, duration = 100, animation = "spore", offset = Vector2(0,-50),speedY = -25,fallaccel = 1,speedX = 3})
				create_hitbox({hitboxtype = "projectile",damage = 16, duration = 100, animation = "spore", offset = Vector2(0,-50),speedY = -25,fallaccel = 1,speedX = -3})
				#FARTHER

				create_hitbox({hitboxtype = "projectile",damage = 16, duration = 100, animation = "spore", offset = Vector2(0,-50),speedY = -25,fallaccel = 1,speedX = 6})
				create_hitbox({hitboxtype = "projectile",damage = 16, duration = 100, animation = "spore", offset = Vector2(0,-50),speedY = -25,fallaccel = 1,speedX = -6})

			if frame == 80:
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