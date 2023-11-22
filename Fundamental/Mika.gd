#disaster bi code

extends "res://Fundamental/Entity.gd"


var jumpstrength = 350
var jumpstrength_heldbase = 60 #every frame
var jumpstrength_heldadd = 18 #first few frames 
var driftaccel = 100
var driftspeed_max = 475
var air_friction = 15 #per frame
var ground_traction = 35 #per frame
var double_traction_threshold = 600 #traction is double above this point

var walkaccel := 125
var walkspeed_max := 500
var crawlspeed_max := 165


var dashes_max = 1
var walljumps_max = 2
var gravity_exceptions:Array[String] = ["dashstart","forwarddash","downdash","novdash","wallcling","ninebutton",]
 
#not stats
var dashes := 0
var walljumps := 0
var dashing:bool= false #used for visuals only
var airframes := 0 #used for adjustable jump height 
var storedvelocity := 0 #used for walljumping preserving momentum probably




func _ready():
	#initialization
	state = "air"
	team = "mika"
	show_info = false
	
	#custom values
	hp = 80
	hp_max = 80
	fallaccel = 25
	fallspeed_max = 900
	realscale = 0.18

	hitsound = "hitmika"
	hitvolume = -5.0

func _physics_process(delta):
	if hitstop == 0:
		if invulntimer > 0: invulntimer -= 1
		state_caller()
		move_and_slide()
		
		if state not in gravity_exceptions: gravity() #this is wonky 
		state_called = [] #put this after all state logic always 
	update_animation()
	if inputpressed("ninebutton"):
		nstate("ninebutton")



	
	
	tickframe()




#Runs the func for each state. This is done individually for each state because call_deferred() doesn't work right
func state_caller():
	if statecheck("stand"): stand_state()
	if statecheck("air"): air_state()
	if statecheck("walk"): walk_state()
	if statecheck("dashstart"): dashstart_state()
	if statecheck("forwarddash"): forwarddash_state()
	if statecheck("updash"): updash_state()
	if statecheck("downdash"): downdash_state()
	if statecheck("novdash"): novdash_state()
	if statecheck("tridash"): tridash_state()
	if statecheck("wallcling"): wallcling_state()
	if statecheck("walljump") : walljump_state()

	if statecheck("groundstrike1"): groundstrike1_state()
	if statecheck("groundstrike2"): groundstrike2_state()
	if statecheck("groundstrike3"): groundstrike3_state()
	if statecheck("upstrike"): pass
	if statecheck("downstrike"): pass
	
	if statecheck("forwardair"): forwardair_state()
	if statecheck("backair"): backair_state()

	if statecheck("hitstunair"): hitstunair_state()
	if statecheck("death"): death_state()
	if statecheck("ninebutton"): ninebutton_state()

	#states

func stand_state():
	turn_ok()
	tracting()
	if frame == 0: landevent()
	if inputheld("left") or inputheld("right"):
		nstate("walk")
	
	jumpcheck()
	dashcheck()
	slideoff()
	attackOK_ground()


func walk_state():
	turn_ok()
	tracting()
	if inputheld("down"):
		xvelocity_towards((walkaccel+ground_traction)*direction,crawlspeed_max)
	else:
		xvelocity_towards((walkaccel+ground_traction)*direction,walkspeed_max)
	
	if !inputheld("left") and !inputheld("right"):
		momentumreset(200)
		velocity.y +=100
		nstate("stand")
	
	jumpcheck()
	dashcheck()
	attackOK_ground()
	if !is_on_floor(): nstate("air")
	if frame == 36: frame = 0 #too lazy to program looping anims correctly


func air_state():
	silhouette()
	drift()
	dashcheck()
	attackOK_air()

	if airframes > 0 and inputheld("A"):
		if airframes > 10:
			velocity.y -= jumpstrength_heldadd * 3
		if airframes > 8:
			velocity.y -= jumpstrength_heldadd * 2
		velocity.y -= jumpstrength_heldbase
		airframes -= 1
	if not inputheld("A"): airframes = 0
	#Wall cling
	if frame > 3: wallclingcheck() #frame is completely arbitrary 
	
	if is_on_floor() and frame > 1:
		sfx("land")
		nstate("stand")
	

func dashstart_state():
	if frame == 0:
		dashing = true
		momentumreset(200)
		velocity.y = 0
		airframes = 0
		if invulntimer < 4: invulntimer = 4
		
	position.x -= velocity.x / 60 #wacky hack to make you stop in the air without erasing velocity 
	
	if frame == 4:
		sfx("dash")
		match direction_held():
			"1":
				flip()
				nstate("tridash")
			"2":
				nstate("downdash")
			"3":
				nstate("tridash")
			"4":
				flip()
				nstate("forwarddash")
			"5":
				nstate("forwarddash")
			"6":
				nstate("forwarddash")
			"7":
				flip()
				nstate("novdash")
			"8":
				nstate("updash")
			"9":
				nstate("novdash")
	
	


	
	if frame == 10:
		endstate()

func updash_state():
	silhouette()
	fricting()
	wallclingcheck()
	if frame == 0:
		if velocity.y > 0: momentumresetY(600)
		momentumresetY(200)
		velocity.y -= 1000
	if frame > 0: attackOK_air()
	if frame == 9:
		airframes = 0 #what the fuck?
		endstate()


func forwarddash_state():
	silhouette()
	fricting()
	wallclingcheck()
	if frame == 0:
		airframes = 0
		if direction*velocity.x < 0:
			momentumreset(300)
		
		xvelocity_towards(900*direction, 5000)
	if frame > 0:
		if is_on_floor():
			attackOK_ground()
			if inputheld("L"): jumpcheck()
		else:attackOK_air()

	if frame > 0 and frame <= 9:
		xvelocity_towards((10 + frame*5 )*direction, 900)
	
	if frame >= 9:
		if is_on_floor():
			dashes = 0
			jumpcheck()
			dashing = true
			tracting()

	if frame == 14:
		endstate()
		


func downdash_state():
	silhouette()
	fricting()
	wallclingcheck()
	if frame == 0:
		momentumreset(600)
		velocity.y += 1300
	if frame > 0: attackOK_air()
	if is_on_floor():
		dashes = 0
		dashing = true
		
	if frame == 14:
		endstate()

func novdash_state():
	silhouette()
	fricting()
	wallclingcheck()
	if frame == 0:
		if direction*velocity.x < 0:
			momentumreset(500)
		xvelocity_towards(450*direction, 5000)
		if velocity.y > 0: momentumresetY(800)
		momentumresetY(150)
		velocity.y -= 550
	if frame > 0: attackOK_air()
	if frame > 0 and frame <= 9:
		xvelocity_towards((5 + frame*2 )*direction, 900)
	
	if frame == 14:
		airframes = 0 #this is so hack fucky but I don't care to fix this
		endstate()

func tridash_state():
	silhouette()
	fricting()
	wallclingcheck()
	if frame == 0:
		if direction*velocity.x < 0:
			momentumreset(600)
		xvelocity_towards(500*direction, 1200)
		velocity.y += 900
	if frame > 0: attackOK_both()
	if frame > 0 and frame <= 9:
		xvelocity_towards((5 + frame*2 )*direction, 900)
	
	if frame >= 4:
		if is_on_floor():
			if dashes != 0: sfx("land")
			dashing = true
			dashes = 0
			attackOK_ground()
	
	if frame >= 9:
		if is_on_floor():
			jumpcheck()
	if frame == 14:
		endstate()
	

func wallcling_state():
	velocity.y = 0
	if inputheld("down"): velocity.y = fallaccel * 10
	drift() # so you continue to speed into the wall I think
	if !is_on_wall() or \
	( (!inputheld("left") and direction == 1 ) or !inputheld("right") and direction == -1):
		endstate()
	if inputpressed("A") and walljumps < walljumps_max:
		walljumps+=1
		nstate("walljump")


func walljump_state():
	if frame == 0:
		velocity.x += 650*direction
		velocity.y -= 850
		
#	if frame >0 and frame < 5:
#		xvelocity_towards(9*direction,1500)
	#insert attack cancel
	if frame >= 1:
		dashcheck()
	
	if frame == 8:
		endstate()


func groundstrike1_state():
	tracting()
	slideoff()
	attackwalking()

	if frame == 6:
		sfx("swing1",-4)
		create_hitbox({damage = 8,duration = 5, offset = Vector2(80,-55),scale = Vector2(3,3.5)})
	if frame > 6:
		if inputpressed("B",5+4): #increased buffer for successive attacks
			nstate("groundstrike2")
	if frame == 24:
		endstate()

func groundstrike2_state():
	tracting()
	slideoff()
	
	if frame == 5:
		sfx("swing1",-4)
		create_hitbox({damage = 8,duration = 4, offset = Vector2(42,-55),scale = Vector2(5,5)})
	if frame > 5 and inputpressed("B",9):
		nstate("groundstrike3")
	if frame == 25:
		endstate()

func groundstrike3_state():
	tracting()
	slideoff()
	
	if frame == 5:
		sfx("swing1",-4,0.8)
		create_hitbox({damage = 16,duration = 9, offset = Vector2(120,-80),scale = Vector2(4.1,3)})
	
	if frame == 32:
		endstate()

func upstrike_state():
	pass

func downstrike_state():
	pass

	if frame == 30:
		endstate()

func forwardair_state():
	if true or frame > 0 or (frame == 0 and prevstate != "air"): #without this you can drift twice in 1 frame
		fricting()
		drift()

	if is_on_floor(): nstate("stand")
	
	
	if frame == 3:
		sfx("swing1",-4,1.1)
		create_hitbox({damage = 8,duration = 3, offset = Vector2(80,-85),scale = Vector2(4,4)})
	if frame == 21:
		endstate()

func backair_state():
	flip()
	nstate("forwardair") #placeholder?

func ninebutton_state():
	position -= velocity / 60
	if frame == 0:
		sfx("nine",-5)
		if invulntimer < 120: invulntimer = 120
		dashes = 0
		walljumps = 0
		if velocity.y > 0: velocity.y = 0
		heal(16)
		if get_parent().get_parent().currentlevel != "MansionNineButtonTutorial":
			global.gamesave.ninebuttonuses+=1
		
	if frame == 20:
		endstate()

#hitstunground was planned but I might not do that. It was meant to have less stun and knockback
#so staying on the ground was more advantageous and you could intentionally get hit on the floor
#for more advantage
func hitstunair_state():
	if frame == 0:
		momentumreset(3000)
		momentumresetY(1000)
		velocity.y = -800
		velocity.x = direction * - 800
	gravity()
	fricting()
	fricting()
	
	if frame == 42:
		endstate()

func hitstunground_state():
	pass


func die():
	if state != "death": nstate("death")
func death_state():
	if frame == 0:
		get_parent().get_parent().get_parent().playmusic("death",-10,false)
		invulntimer = 1000
		global.gamesave.hp = hp_max
	modulate.a -= 0.003
	fricting()
	var camera = get_parent().get_parent().get_node("Camera2D")
	camera.zoom += Vector2(0.005,0.005)
	
	if frame == 450:
		get_tree().reload_current_scene() #placeholder 
	

							#state machine helpers

func attackOK_ground():
	if inputpressed("B"):
		if global.gamesave.progression >= 1:
			match direction_held():
				
				"5":
					nstate("groundstrike1")
				"6":
					nstate("groundstrike1")
				"1":
					nstate("groundstrike1")
				"3":
					nstate("groundstrike1")
				"2":
					if true:
						nstate("groundstrike1")


func attackOK_air():
	if inputpressed("B"):
		if global.gamesave.progression >= 1:
				var dirheld:String = direction_held()
				if state in ["forwarddash","novdash"]: momentumreset(100)
				if dirheld in ["4","1","7"]:
					nstate("backair")
				elif dirheld in ["5","6","3","9","8","2",]:
					nstate("forwardair")

func attackOK_both():
	if is_on_floor():
		attackOK_ground()
	else:
		attackOK_air()

func dashcheck():
	if inputpressed("L") and dashes < dashes_max:
		nstate("dashstart")
		dashes+=1
		airframes = 0


func wallclingcheck():
	if is_on_wall_only() and !inputheld("A"):
		if $WallCheckerL.colliding == true:
			if state == "air" and !inputheld("left"): return #this is a mess but its intentional ok,
			nstate("wallcling")
			direction = 1
		if $WallCheckerR.colliding == true:
			if state == "air" and !inputheld("right"): return #only way to keep wallbouncing and sensible wallcling input
			nstate("wallcling")
			direction = -1

func jumpcheck():
	if inputpressed("A"):
		#if state == "forwarddash" or state == "tridash":
		#	position.y -=  5 #hackity fuckity hack
		### ^^ I removed this cause I forgoy why I did this in the first place and it seems to work fine
		nstate("air")
		velocity.y -= jumpstrength
		airframes = 12
		

func slideoff():
	if !is_on_floor():
		nstate("air")

func landevent(): #not sure what im using this for 
	airframes = 0
	dashes = 0
	walljumps = 0
	dashing = false 

func attackwalking():
	var speedmax := walkspeed_max
	if inputheld("down"): speedmax = crawlspeed_max
	if inputheld("left"):
		xvelocity_towards((walkaccel+ground_traction)*-1,speedmax)
	elif inputheld("right"):
		xvelocity_towards((walkaccel+ground_traction)*1,speedmax)

##Used for drifting left/right and friction
func drift():
	if airframes >0: airframes -= 1
	if inputheld("left"):
		xvelocity_towards(driftaccel*-1,driftspeed_max)
	if inputheld("right"):
		xvelocity_towards(driftaccel,driftspeed_max)
	if (!inputheld("left") and !inputheld("right")) or abs(velocity.x) > driftspeed_max:
		fricting()

func fricting():
	var initialspeed = velocity.x
	if initialspeed > 0: #going right, friction pushing back left 
		velocity.x -= air_friction
		if velocity.x < 0: velocity.x = 0
	else: #going left, friction pushing back right 
		velocity.x += air_friction
		if velocity.x > 0: velocity.x = 0

func tracting(): #maximum means it will only work above that value. 
	momentumreset(ground_traction)
	if abs(velocity.x) > double_traction_threshold:
		momentumreset(min(ground_traction,abs(velocity.x) - double_traction_threshold ))
		

func momentumreset(momentum): #like traction/friction but w a custom value
	var initialspeed = velocity.x
	if initialspeed > 0: 
		velocity.x -= momentum
		if velocity.x < 0: velocity.x = 0
	else:
		velocity.x += momentum
		if velocity.x > 0: velocity.x = 0

func momentumresetY(momentum): #like the above but lame
	var initialspeed = velocity.y
	if initialspeed > 0: 
		velocity.y -= momentum
		if velocity.y < 0: velocity.y = 0
	else:
		velocity.y += momentum
		if velocity.y > 0: velocity.y = 0	


##Lets your turn around the character if this is in a state.
##the buffer stuff is meant to prioritize the latest held button
func turn_ok():
	var buffer:Dictionary = get_parent().get_parent().buffer
	if inputheld("left"):
		direction = -1

	if inputheld("right"):
		direction = 1


func flip():
	direction *= -1


func endstate():
	if is_on_floor():
		nstate("stand")
	else:
		nstate("air")


	#visual

func silhouette():
	if frame % 3 and dashing:
		var sillhouette_node = preload("res://Polish/silhouette.tscn").instantiate()
		get_parent().add_child(sillhouette_node)
		sillhouette_node.position = $sprite.global_position + $sprite.offset * abs($sprite.scale.x) #this is fucked
		sillhouette_node.texture = $sprite.sprite_frames.get_frame_texture($sprite.animation,$sprite.frame)
		sillhouette_node.scale = $sprite.scale
		if dashes > 0:
			sillhouette_node.modulate = Color(0.8,0.7,1,0.7)
		else:
			sillhouette_node.modulate = Color(0.4,1,0.2,0.7)


	#Physics stuff

##Changes non-absolute velocity in given direction with an absolute maximum
func xvelocity_towards(addedvel:int,maximum):
	var sign = abs(addedvel) / addedvel
	if abs(velocity.x) > maximum: return
	velocity.x += addedvel
	if abs(velocity.x) > maximum:
		velocity.x = maximum * sign

		##Input

#These essentially just call back to Gameplay node, it's more convenient than calling back to it each time

func inputheld(input:String) -> bool:
	return get_parent().get_parent().inputheld(input)

func inputpressed(input:String,buffernum:int= get_parent().get_parent().standardbuffer) -> bool:
	return get_parent().get_parent().inputpressed(input,buffernum)

func direction_held() -> String:
	return get_parent().get_parent().direction_held(direction)

	#Other Gameplay node references


	
