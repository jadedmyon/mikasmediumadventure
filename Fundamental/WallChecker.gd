extends Area2D

var colliding := false 

func _physics_process(delta):
	collision_check()
	#print (str(colliding) + name)



func collision_check(): #separated into function so I could return
	for x in get_overlapping_bodies():
		if x is TileMap:
			colliding = true
			return #meaning the false check can never happen if 1 collision check happens
	colliding = false
