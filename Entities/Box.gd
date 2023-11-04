extends "res://Fundamental/Entity.gd"

func _ready():
	
	hp = 20


func _physics_process(delta):
	tickframe()
	if hitstop == 0:

		move_and_slide()
		gravity()
		update_animation()
		state_called = []
		if frame == 90:
			#create_hitbox({hitboxtype = "projectile",damage=1,duration = 90, scale = Vector2(8,8)})
			frame = 0
