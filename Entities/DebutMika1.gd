extends "res://Fundamental/Entity.gd"

func _ready():
	hp = 200
	
	
	fallaccel = 25
	fallspeed_max = 900
	realscale = 0.18

func state_caller():

	if statecheck("stand"): stand_state()
	if statecheck("runin"): runin_state()
	if statecheck("raisedust"): raisedust_state()
	if statecheck("dashattack"): dashattack_state()
	if statecheck("jumpblast"): jumpblast_state()
	if statecheck("groundedhalfcircle"): groundedhalfcircle_state()
	if statecheck("hitstun"): hitstun_state()
	if statecheck("dashattackslip"): dashattackslip_state()


func stand_state():
	if frame == 0:
		vulnerable = false
	if frame == 30:
		if true: #hp > hp_max - 16
			nstate("dashattack")
			nstate("raisedust")
		else:
			var rng := randi() % 5
			match rng:
				0:
					nstate("runin")
				1:
					nstate("raisedust")
				2:
					nstate("dashattack")
				3:
					nstate("jumpblast")
				4:
					nstate("groundedhalfcircle")



func runin_state():
	pass

func raisedust_state():
	if frame == 0:
		invulntimer = 80
	
	if frame == 40:
		pass
		for x in 10: shootdust()
	
	if frame == 50:
		for x in 8: shootdust()

	if frame == 60:
		for x in 5: shootdust()
	
	if frame == 70:
		for x in 2: shootdust()

	if frame == 50:
		vulnerable = true
	
	
	if frame == 150:
		nstate("stand")

func dashattack_state():
	if frame == 0:
		lookat_mika()
		create_hitbox({damage=12,duration=40, scale = Vector2(4,5), offset = Vector2(0,-100) })
	if frame >= 1 and frame < 90:
		xvelocity_towards((90)*direction,700)
	if frame == 30:
		nstate("dashattackslip")


func dashattackslip_state():
	tracting()
	if frame == 1:
		create_hitbox({damage=12,duration=10,scale = Vector2(4,5), offset = Vector2(0,-100)}) #late hitbox
	if frame == 30:
		vulnerable = true
	
	if frame == 100:
		nstate("stand")


func jumpblast_state():
	pass

func groundedhalfcircle_state():
	pass

func hitstun_state():
	if frame == 0:
		velocity.x = 0
		velocity.y = 0
		vulnerable = false
		print ("GHBSDKFGSJDG;F!!!!")
	if frame == 500 or currentstatedamage > 50:
		nstate("stand")
		

func shootdust():
	var rngX :float= ( randi() % 70 ) / 10
	var rngY :float= ( randi() % 10 )  / 3
	var rngFall:float= ( randi() % 6 ) / 10
	
	var params:Dictionary = {
		hitboxtype = "projectile",damage = 10, duration = 600, 
		animation = "dustbullet", scale = Vector2(2,2),
		offset = Vector2(0,-90),fallaccel = 0.5+ rngFall, speedX = 10+rngX, speedY = -5-rngY,speedscale = 1,}

	create_hitbox(params)


#Mika code copying for convenience

var ground_traction = 10 #per frame
var double_traction_threshold = 600 #traction is double above this point

func momentumreset(momentum): #like traction/friction but w a custom value
	var initialspeed = velocity.x
	if initialspeed > 0: 
		velocity.x -= momentum
		if velocity.x < 0: velocity.x = 0
	else:
		velocity.x += momentum
		if velocity.x > 0: velocity.x = 0

func tracting(): #maximum means it will only work above that value. 
	momentumreset(ground_traction)
	if abs(velocity.x) > double_traction_threshold:
		momentumreset(min(ground_traction,abs(velocity.x) - double_traction_threshold ))
	

func xvelocity_towards(addedvel:int,maximum):
	var sign = abs(addedvel) / addedvel
	if abs(velocity.x) > maximum: return
	velocity.x += addedvel
	if abs(velocity.x) > maximum:
		velocity.x = maximum * sign

		#generally useful boss stuff

func lookat_mika():
		if mikahurtboxpos().x > position.x:
			direction = 1
		else:
			direction = -1

func findmika() -> Node:
	for x in get_parent().get_children():
		if x.name == "Mika":
			return x
	return null

func mikahurtboxpos() -> Vector2:
	return findmika().get_node("Hurtbox").global_position
