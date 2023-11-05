extends "res://Fundamental/Entity.gd"


func _ready():
	displayname = "Dust Bunny"
	fallaccel = 12
	process_priority = 1
	realscale = 1.1


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
				velocity.x = 0 
			if mikadetected:
				direction = mikadirection
				var rng := randi() % 2
				if rng == 0:
					nstate("smalljump")
				else:
					nstate("windup")
			
		"smalljump":
			if frame == 1:
				fallaccel = 12
				create_hitbox({damage=8,duration=120, scale = Vector2(3,3)})
				velocity.y = - 250
				velocity.x = direction * 240
			if frame > 5 and is_on_floor():
				nstate("stand")
				dustoomf()
		"bigjump":
			if frame == 1:
				fallaccel = 23
				create_hitbox({damage=8,duration=120, scale = Vector2(2,2)})
				velocity.y = - 450
				velocity.x = direction * 500
			if frame > 5 and is_on_floor():
				nstate("stand")
				dustoomf()
				

		"windup":
			if frame == 25:
				nstate("bigjump")



func dustoomf():
	var dustoomf = preload("res://Entities/DustOomf.tscn").instantiate()
	dustoomf.position = position
	get_parent().add_child(dustoomf)