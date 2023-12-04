extends "res://Fundamental/Entity.gd"


func _ready():
	fallaccel = 12
	process_priority = 1 #I have 0 clue why I did this 
	realscale = 1.2
	hp = 8


func uniquebehavior():
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
			if frame == 5:
				sfx("jumpsmall")
				fallaccel = 12
				create_hitbox({damage=8,duration=120, scale = Vector2(3,5)})
				velocity.y = - 250
				velocity.x = direction * 240
			if frame > 5 and is_on_floor():
				nstate("stand")
				dustoomf()
		"bigjump":
			if frame == 1:
				sfx("jumpbig")
				fallaccel = 23
				create_hitbox({damage=8,duration=120, scale = Vector2(3,5)})
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
