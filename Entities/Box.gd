extends "res://Fundamental/Entity.gd"

func _ready():
	
	hp = 6
	#hitsound = "hitsmall"
	hitvolume = -18
	show_info = false

func _physics_process(delta):
	tickframe()
	if hitstop == 0:
		mikacollision_bounce()
		move_and_slide()
		gravity()
		update_animation()
		state_called = []
		if frame == 90:
			#create_hitbox({hitboxtype = "projectile",damage=1,duration = 90, scale = Vector2(8,8)})
			frame = 0
