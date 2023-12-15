extends "res://Fundamental/Entity.gd"


var hitstundmgthreshold = 80


var ennadelayedhitbox:Dictionary = {hitboxtype = "projectile", speedX = 0, speedY = 0, animation = "delayedprojectile",
	destroyontilemap = false,
	damage = 20, duration = 29,
	scale = Vector2(4,4), fadeoutspeed = 0.022, } 


func _ready():
	boss = true
	hp = 540
	fallaccel = 15
	fallspeed_max = 900
	hitsoundrandoms = ["enna-fucking","enna-bitch","enna-fuck","enna-questionmark","enna-kya"]
	checkvn()


func checkvn():
	for x in get_parent().get_children():
		if x.name == "EnnaTrigger":
			if x.scenename in global.gamesave.playedvns:
				state = "stand"
				return
	state = "unaggressive"


func state_caller():
	if statecheck("stand"): stand_state()
	if statecheck("calm"): calm_state()
	if statecheck("rest"): rest_state()
	if statecheck("hitstun"): hitstun_state()
	if statecheck("unaggressive"): pass

	if statecheck("pattern1setup"): pattern1setup_state()
	if statecheck("pattern3setup"): pattern3setup_state()
	if statecheck("pattern4setup"): pattern4setup_state()
	
	if statecheck("pattern1"): pattern1_state()
	if statecheck("pattern2"): pattern2_state()
	if statecheck("pattern3"): pattern3_state()
	if statecheck("pattern4"): pattern4_state()
	if statecheck("pattern5"): pattern5_state()

#	print (state + "    " + str(frame))






func stand_state():
	if frame == 0:
		fallaccel = 15
		$sprite.offset= Vector2(0,0)
	
	if frame >= 10:
		var percent = ( float( hp) / hp_max ) * 100

		if percent > 85:
			nstate("pattern1setup")
		elif percent > 50:
			nstate("pattern2")
		elif percent > 25:
			nstate("pattern3setup")
		elif percent > 0:
			nstate("pattern4setup")




		


##When Enna is defeated
func calm_state():
	if frame == 0:
		hp = 1
		team = "mika"
		fallaccel = 35
		velocity.x = 0
		velocity.y = 0
		var explosion := preload("res://Polish/DeathExplode.tscn").instantiate()
		get_parent().add_child(explosion)
		explosion.scale *= 2
		explosion.position = $sprite.global_position
	if frame == 60:
		createvn("postenna")

func rest_state():
	if frame == 0:
		fallaccel = 20
		vulnerable = true
		damagetaken_mult = 1.5
		lookat_mika()
		$sprite.offset= Vector2(0,0)
	
	momentumreset(2)
	
	if frame == 150:
		nstate("stand")

func hitstun_state():
	tracting()
	if frame == 0:
		velocity.y = -300
		velocity.x = direction * 800
		vulnerable = false
		invulntimer = 30
		fallaccel = 15
		$sprite.offset= Vector2(200*direction,0)
	if frame >= 300 or currentstatedamage > hitstundmgthreshold:
		nstate("stand")
		damagetaken_mult = 1.0



func die():
	update_enemyinfo(null)
	invulntimer = 500
	nstate("calm")
	


func pattern1setup_state():
	if frame == 0:
		randomdirection()
		fallaccel = 0

	velocity.x = 600 * direction
	velocity.y = 140
	
	if is_on_floor() and is_on_wall() or frame > 90:
		nstate("pattern1")

func pattern3setup_state():
	if frame == 0:
		randomdirection()
		velocity.x = 0
		velocity.y = -500
		fallaccel = 15
	
	var frames_to_rise = [50,100,140] 
	for x in frames_to_rise:
		if frame == x:
			velocity.y -= 800
	
	if frame == 150:
		velocity.y = 0
		fallaccel = 1
		nstate("pattern3")

func pattern4setup_state():
	if frame == 0:
		randomdirection()
		fallaccel = 0
		invulntimer = 40
	
	velocity.x = 800 * direction
	velocity.y = 240
	
	if (is_on_floor() and is_on_wall()) or frame > 60:
		invulntimer = 0
		nstate("pattern4")


func spawntruth():
	if not global.gamesave.ennatruthed:
			global.gamesave.ennatruthed = true
			var ennatruth := preload("res://Polish/ennatruth.tscn").instantiate()
			get_parent().add_child(ennatruth)
			ennatruth.position = position + Vector2(-300,-200)


func pattern1_state():
	


	if frame % 21 == 0 and frame < 299:
		var rng = (randi() % 2 ) * 2
		shootp1(0+rng)
		shootp1(150+rng)
		shootp1(90+rng)
	velocity.x = -80 * direction
	if frame <= 299:
		velocity.y = 550 * direction
	if frame <= 299:
		if frame % 25 == 0: direction *= -1
		if frame % 69 == 0:
			create_delayedhitbox(60,Vector2(4,4),
		mikahurtboxpos(),ennadelayedhitbox)
		
	
	if frame == 300:
		velocity.y = 0
		fallaccel = 20

	if frame == 250:
		nstate("rest")

func pattern2_state():
	if frame == 0:
		fallaccel = 2
		
	if frame <= 150:
		velocity.x = 0
		velocity.y = 0
	if frame > 0 and frame < 120:
		if frame % 17 == 0:
			shootp2(float(frame)/8)
	
	if frame == 0:
		spawntruth()
	if frame >= 20 and frame < 30:
		velocity.x = 1000 * direction
		velocity.y = -1400
		
	if frame  >= 40 and frame < 50:
		velocity.x = -1900 * direction
		velocity.y = -100
	if frame >= 60 and frame < 70:
		velocity.x = 1000 * direction
		velocity.y = -500
	if frame >= 80 and frame < 90:
		velocity.x = direction * -2100
		velocity.y = -900
	if frame >= 90 and frame < 96:
		velocity.x = direction * 3500

	if frame == 200:
		nstate("rest")


func pattern3_state():
	if frame < 150:
		if frame % 30 == 0:
			create_delayedhitbox(60,Vector2(4,4),
		mikahurtboxpos(),ennadelayedhitbox)
		if frame % 8 == 0:
			shootp3()
			shootp3(11.15)

		if frame % 40 == 0:
			direction *= -1

		velocity.x = direction * 1500
	
	
	
	
	if frame == 200:
		nstate("rest")

func pattern4_state():
	if frame == 0:
		velocity.y = -90
		direction*= -1
		velocity.x = direction * 50
	if frame < 310:
		if frame % 44 == 0:
			shootp4()
		if frame < 150:
			if frame % 17 == 0:
				create_delayedhitbox(60,Vector2(4,4), mikahurtboxpos(),ennadelayedhitbox)
		else:
			if frame % 8 == 0:
				create_delayedhitbox(60,Vector2(4,4), mikahurtboxpos(),ennadelayedhitbox)
	if frame == 310:
		nstate("rest")

func pattern5_state():
	pass




#helper

func randomdirection():
	var rng =  (randi() % 2 ) * 2
	direction = -1 + rng


func shootp1(addangle=0):
	sfx("feather",-15)
	var rng = randi() % 2
	var hitbox = {
		hitboxtype = "projectile",damage = 20, duration = 900, 
		animation = "feather-blue-bright", scale = Vector2(2.3,2.3),
		polygonscale = Vector2(0.5,0.25),
		offset = Vector2(0,-100),
		angle = 0 + addangle,
		anglevelocity = 6+rng, adjustanglevisual = "onstart",
		destroyontilemap = false,
		}
	create_hitbox(hitbox)
	hitbox.angle *= -1
	hitbox.angle += 180
	create_hitbox(hitbox)


func shootp2(angleoffset:int=0):
	sfx("feather",-7,1.5)
	var addangle = 5.9
	var hitbox = {
		hitboxtype = "projectile",damage = 20, duration = 900, 
		animation = "feather-emerald", scale = Vector2(1.9,1.9),
		polygonscale = Vector2(0.5,0.25),
		offset = Vector2(0,-100),
		angle = 0 + addangle + angleoffset,
		anglevelocity = 3, adjustanglevisual = "onstart",
		destroyontilemap = false,
		}
	for x in 34:
		if x % 2 == 0:
			hitbox.animation = "feather-purple-bright"
		else:
			hitbox.animation = "feather-blue-light"
		hitbox.angle += addangle * x
		create_hitbox(hitbox)


func shootp3(addangle=0):
	sfx("feather",-19,0.6)
	var rng = randi() % 2
	var hitbox = {
		hitboxtype = "projectile",damage = 20, duration = 900, 
		animation = "feather-emerald-dark", scale = Vector2(2.0,2.0),
		polygonscale = Vector2(0.5,0.25),
		offset = Vector2(0,-100),
		angle = 90 + addangle,
		anglevelocity = 5+rng, adjustanglevisual = "onstart",
		destroyontilemap = false,
		}
	create_hitbox(hitbox)
	hitbox.angle *= -1
	hitbox.angle += 180
	create_hitbox(hitbox)

func shootp4(angleoffset:int=0):
	sfx("feather",-7,1.5)
	var addangle = 12.37
	var hitbox = {
		hitboxtype = "projectile",damage = 19, duration = 900, 
		animation = "feather-emerald", scale = Vector2(1.9,1.9),
		polygonscale = Vector2(0.5,0.25),
		offset = Vector2(0,-100),
		angle = 0 + addangle + angleoffset,
		anglevelocity = 3, adjustanglevisual = "onstart",
		destroyontilemap = false,
		}
	for x in 16:
		if x % 2 == 0:
			hitbox.animation = "feather-purple-bright"
		else:
			hitbox.animation = "feather-blue-light"
		hitbox.angle += addangle * x
		create_hitbox(hitbox)


#copypaste

var ground_traction = 10 #per frame
var double_traction_threshold = 600 #traction is double above this point


func tracting(): #maximum means it will only work above that value. 
	momentumreset(ground_traction)
	if abs(velocity.x) > double_traction_threshold:
		momentumreset(min(ground_traction,abs(velocity.x) - double_traction_threshold ))
