extends "res://Fundamental/Entity.gd"

var nextstate := "groundedhalfcircle"
var walklength := 40 #frames
var hitstundmgthreshold = 40


var fallaccel_default = 25

func _ready():
	displayname = "Debut Mika I"
	hp = 685
	
	
	fallaccel = fallaccel_default
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
	if statecheck("walktomika"): walktomika_state()
	if statecheck("fuckyou"): fuckyou_state()

	if state == "hitstun": damagetaken_mult = 1.5
	else: damagetaken_mult = 1.0

func stand_state():
	if frame == 0:
		vulnerable = false
		fallaccel_default = 25
		hitstundmgthreshold = 40
	if frame == 20:
		if true: #hp > hp_max - 16
			nstate("dashattack")
			nstate("raisedust")
			nextstate = "jumpblast"
			nstate("walktomika")
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
					nextstate = "groundedhalfcircle"
					walklength = 20
					nstate("walktomika")
				5:
					nextstate = "jumpblast"
					walklength = 40
					nstate("walktomika")


func runin_state():
	pass

func raisedust_state():
	if frame == 0:
		invulntimer = 80
		lookat_mika()
	
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
		create_hitbox({damage=12,duration=30,scale = Vector2(4,5), offset = Vector2(0,-100)}) #late hitbox
	if frame == 30:
		vulnerable = true
	
	if frame == 90:
		nstate("stand")


func jumpblast_state():
	if frame == 0:
		invulntimer = 50
		velocity.y = -1860
		hitstundmgthreshold = 80
	#if frame >= 0 and frame <= 3:
	#	velocity.y += 300
	if frame >= 0 and frame <= 5:
		velocity.y += 80
	if frame >= 0 and frame <= 10:
		velocity.y += 35
	
	if frame == 20:
		fallaccel = 0
		velocity.y = 0

	shootvolleyside(50)
	shootvolleyside(55,-1)
	
	shootvolleyside(60,1,45,3)
	shootvolleyside(60,-1,45,3)
	
	shootvolleyside(80)
	shootvolleyside(80,-1)
	
	
	

	if frame == 110:
		vulnerable = true
		fallaccel = 16
	
	
	if frame > 130 and is_on_floor():
		vulnerable = false
		var rng := randi() % 2
		hitstundmgthreshold = 40
		if rng == 0:

			nstate("dashattack")
		else:
			nstate("raisedust")

func groundedhalfcircle_state():
	pass

func hitstun_state():
	tracting()
	if frame == 0:
		velocity.y = -300
		velocity.x = direction * - 800
		vulnerable = false
		invulntimer = 30
		fallaccel = fallaccel_default
	if frame == 250 or currentstatedamage > hitstundmgthreshold:
		nstate("stand")
		invulntimer = 5
		

func walktomika_state():
	if frame == 0: lookat_mika()
	if frame >= 1 and frame <= walklength:
		xvelocity_towards((150)*direction,500)
	
	if frame == walklength + 1:
		velocity.x = 0 
		nstate(nextstate)


func fuckyou_state():
	if frame == 0:
		invulntimer = 200

	if frame == 100:
		pass #fuck you beam
		
	
	if frame == 200:
		pass #start vn 
	
	


func shootdust():
	var rngX :float= ( randi() % 70 ) / 10
	var rngY :float= ( randi() % 10 )  / 3
	var rngFall:float= ( randi() % 6 ) / 10
	
	var params:Dictionary = {
		hitboxtype = "projectile",damage = 10, duration = 600, 
		animation = "dustbullet", scale = Vector2(2,2),
		offset = Vector2(0,-90),fallaccel = 0.5+ rngFall, speedX = 10+rngX, speedY = -5-rngY,speedscale = 1,}

	create_hitbox(params)

func shootblast(addangle:int=0):
	
	var params:Dictionary = {
		hitboxtype = "projectile",damage = 10, duration = 300, 
		animation = "bullet", scale = Vector2(1,1), polygonscale = Vector2(0.5,0.5),
		offset = Vector2(0,0),
		angle = 0 + addangle,
		anglevelocity = 5,
		}

	create_hitbox(params)

##Fuck this specific function I hope it works
func shootvolleyside(startframe:int=50,side:int=1,offset:int=90,times:int=4):
	
	for y in times:
		if frame == startframe + y*8:
			var angledrift = 0
			if times % 2 == 0: angledrift = 8
			
			
			for x in 6:
				shootblast(  (side*offset + times*15 + x*(15+angledrift) )   )
	
	


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
