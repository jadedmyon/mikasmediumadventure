extends "res://Fundamental/Entity.gd"

var nextstate := "groundedhalfcircle"
var walklength := 40 #frames
var hitstundmgthreshold = 40
var bumptimes := 0
var bumptimes_max = 2

var fallaccel_default = 25

func _ready():
	displayname = "Debut Mika II"
	hp = 685
	boss = true
	
	fallaccel = fallaccel_default
	fallspeed_max = 900
	realscale = 0.18
	state = "calm"
	team = "mika"
	if global.gamesave.debutmika2talked:
		nstate("stand")
		team = "enemy"
		for x in get_parent().get_children(): if x.name == "DebutMika2Trigger":
			x.queue_free()

func state_caller():

	if statecheck("calm"): calm_state()
	if statecheck("stand"): stand_state()
	if statecheck("runin"): runin_state()
	if statecheck("raisedust"): raisedust_state()
	if statecheck("dashattack"): dashattack_state()
	if statecheck("jumpblast"): jumpblast_state()
	if statecheck("groundedhalfcircle"): groundedhalfcircle_state()
	if statecheck("hitstun"): hitstun_state()
	if statecheck("dashattackslip"): dashattackslip_state()
	if statecheck("walktomika"): walktomika_state()

	if statecheck("death"): death_state()

	if state == "hitstun": damagetaken_mult = 1.5
	else: damagetaken_mult = 1.0


func die():
	update_enemyinfo(null)
	invulntimer = 500
	nstate("death")


func death_state():
	if frame == 1:
		velocity.x = 500 * direction
	momentumreset(40)
	if frame == 120:
		createvn("postdebutmika2")


func calm_state():
	pass

func stand_state():
	if frame == 0:
		vulnerable = false
		fallaccel = fallaccel_default
		hitstundmgthreshold = 40
	if frame == 30:
		if hp > hp_max - 16: #hp > hp_max - 16
			nstate("dashattack")
		else:
			var rng := randi() % 5
			match rng:
				0:
					nstate("dashattack")
				1:
					nstate("raisedust")
				2:
					nstate("dashattack")
				3:
					nstate("jumpblast")
				4:
					nextstate = "groundedhalfcircle"
					walklength = 40
					nstate("walktomika")
				5:
					nextstate = "jumpblast"
					walklength = 15
					nstate("walktomika")


func runin_state():
	pass

func raisedust_state():
	if frame == 0:
		invulntimer = 80
		momentumreset(4000)
		lookat_mika()
	
	if frame > 20 and frame < 60:
		xvelocity_towards(31*direction,460)
	
	if frame == 40:
		sfx("bunnyshot")
		for x in 20: shootdust()
	if frame == 44:
		sfx("bunnyshot")
	if frame == 50:
		sfx("bunnyshot")
		for x in 16: shootdust()
	if frame == 55:
		sfx("bunnyshot")
	if frame == 60:
		sfx("bunnyshot")
		for x in 8: shootdust()
	if frame == 63:
		sfx("bunnyshot")
	if frame == 68:
		sfx("bunnyshot")
	if frame == 70:
		sfx("bunnyshot")
		for x in 3: shootdust()
	if frame == 71:
		sfx("bunnyshot")
	if frame == 50:
		vulnerable = true
	
	
	if frame == 150:
		nstate("stand")

func dashattack_state():
	if frame == 0:
		lookat_mika()
		create_hitbox({damage=12,duration=40, scale = Vector2(4,5), offset = Vector2(0,-100) })
	if frame >= 1 and frame < 90:
		xvelocity_towards((150)*direction,800)
	
	if frame == 25:
		nstate("dashattackslip")


func dashattackslip_state():
	tracting()
	tracting() #lmao
	if frame == 1:

		var rng = randi() % 4
		match rng:
			0: sfx("bonk")
			1: sfx("punch")
			2:
				sfx("hit1",0,0.7)
				sfx("metalpipe")
			3: sfx("punch")
		create_hitbox({damage=12,duration=30,scale = Vector2(4,5), offset = Vector2(0,-100)}) #late hitbox
	if frame == 20:
		if bumptimes < bumptimes_max:
			bumptimes+=1
			nstate("dashattack")
	if frame == 30:
		vulnerable = true
	
	if frame == 90:
		bumptimes = 0
		nstate("stand")


func jumpblast_state():
	if frame == 0:
		sfx("jumpbig")
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
		velocity.x = 900 * direction

	if frame > 20 and frame < 105:
		if frame % 19 == 0:
			direction *= -1
			velocity.x = 900 * direction
		momentumreset(32)


	shootvolleyside(50)
	shootvolleyside(55,-1)
	
	shootvolleyside(60,1,45,3)
	shootvolleyside(60,-1,45,3)
	
	shootvolleyside(80)
	shootvolleyside(80,-1)
	
	shootvolleyside(95)
	shootvolleyside(95,-1)
	

	if frame == 110:
		vulnerable = true
		fallaccel = 16
	
	
	if frame > 145 and is_on_floor():
		vulnerable = false
		var rng := randi() % 3
		hitstundmgthreshold = 40
		if rng == 0:

			nstate("dashattack")
		elif rng == 1:
			nstate("raisedust")
		else:
			nstate("groundedhalfcircle")
func groundedhalfcircle_state():
	if frame == 0:
		lookat_mika()
	
	if frame == 50:
		shootgroundedblast(0)
		
		shootgroundedblast(180)
	if frame == 65:
		shootgroundedblast(210)
		shootgroundedblast(15)
	if frame == 80:
		shootgroundedblast(220)
	if frame == 90:
		shootgroundedblast(70)
		shootgroundedblast(-35)
	
	if frame == 120:
		shootgroundedblast(-35)
		
		vulnerable = true
	
	if frame == 195:
		nstate("stand")

func hitstun_state():
	tracting()
	if frame == 0:
		velocity.y = -300
		velocity.x = direction * - 800
		vulnerable = false
		invulntimer = 30
		fallaccel = fallaccel_default
		bumptimes = 0
	if frame == 250 or currentstatedamage > hitstundmgthreshold:
		nstate("stand")
		invulntimer = 5
		

func walktomika_state():
	if frame == 0: lookat_mika()
	if frame >= 1 and frame <= walklength:
		xvelocity_towards((150)*direction,900)
	
	if frame == walklength + 1:
		velocity.x = 0 
		nstate(nextstate)


func fuckyou_state():
	if frame == 0:
		fallaccel = fallaccel_default
		momentumreset(4000)
		invulntimer = 200
	if frame == 12:
		sfx("fuckyou")
	
	if frame == 45:
		explosion()
	if frame == 50:
		findmika().invulntimer = 0
		create_hitbox({damage=findmika().hp,duration=2, scale = Vector2(400,500), deathtype = "forceddeath", offset = Vector2(0,-100) })
		pass #fuck you beam
	
	if frame == 100:
		get_parent().get_parent().createvn("postdebutmika1")
		update_enemyinfo(null)

func explosion():
	var explosion := preload("res://Polish/DeathExplode.tscn").instantiate()
	findmika().add_child(explosion)
	explosion.scale = Vector2(12,12)
#	explosion.position = mikahurtboxpos()

func explosion_self():
	var explosion := preload("res://Polish/DeathExplode.tscn").instantiate()
	add_child(explosion)
	explosion.scale = Vector2(5,5)
	explosion.position = Vector2(50,-50)

func shootdust():
	
	var rngX :float= ( randi() % 100 ) / 10
	var rngY :float= ( randi() % 15 )  / 3
	var rngFall:float= ( randi() % 6 ) / 10
	
	var params:Dictionary = {
		hitboxtype = "projectile",damage = 14, duration = 600, 
		animation = "dustbullet", scale = Vector2(2,2),
		offset = Vector2(0,-90),fallaccel = 0.5+ rngFall, speedX = 12+rngX, speedY = -5-rngY,speedscale = 1,}

	create_hitbox(params)

func shootblast(addangle:int=0,newmodulate=Color(1,1,1,1)):
	
	var params:Dictionary = {
		hitboxtype = "projectile",damage = 11, duration = 300, 
		animation = "bullet", scale = Vector2(1,1), polygonscale = Vector2(0.5,0.5),
		offset = Vector2(0,-100),
		angle = 0 + addangle,
		anglevelocity = 5, adjustanglevisual = "onstart", everythingoffset = 12, modulate = newmodulate
		}

	create_hitbox(params)

##Fuck this specific function I hope it works
func shootvolleyside(startframe:int=50,side:int=1,offset:int=90,times:int=4):
	for y in times:
		if frame == startframe + y*8:
			var angledrift = 0
			if times % 2 == 0: angledrift = 8

			for x in 6:
				sfx("shotmedium2",-25)
				shootblast(  (side*offset + times*15 + x*(15+angledrift) )   )
	

func shootgroundedblast(offset:int=180,side:int=1):
	sfx("shotsmall2",0)
	for x in 16:
		
		var angledrift = 0
		if x % 2 == 0: angledrift = 15
		if x % 5 == 0: angledrift = 4
		shootblast(  (side*direction*offset + 15 + x*(10+angledrift) ) , Color(2,1.5,1.5,1 ) )


#Mika code copying for convenience

var ground_traction = 10 #per frame
var double_traction_threshold = 600 #traction is double above this point


func tracting(): #maximum means it will only work above that value. 
	momentumreset(ground_traction)
	if abs(velocity.x) > double_traction_threshold:
		momentumreset(min(ground_traction,abs(velocity.x) - double_traction_threshold ))
	

		#generally useful boss stuff
