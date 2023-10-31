extends "res://Fundamental/Entity.gd"

func _ready():
	hp = 40


func _physics_process(delta):
	tickframe()
	if hitstop == 0:

		move_and_slide()
		gravity()
		update_animation()
		state_called = []
	if frame == 40:
		create_hitbox({hitboxtype="projectile",duration=190})
		frame = 0
		
