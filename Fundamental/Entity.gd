extends CharacterBody2D

#This is the script that Mika and her enemies inherit.
#Having a common script base lets them and their hitboxes interact with one another.
#Necessary child nodes for interpreter to not crash:
#AnimatedSprite2D named "sprite"
#AnimationPlayer named AnimationPlayer (even if you don't use it at all)

#Necessary for game to make sense-
#Area2D named "Hitbox" with a collision child
#A collision polygon named whatever, named ECB in Mika


var state:= "stand"
var prevstate := ""
var frame:= 0
var hitstop:= 0 #should prolly be applied to all children of Entities in Gameplay script
var flashingtimer = 0
@export var direction:= 1 #1 and -1
var invulntimer := 0
var mikadetected := false
var mikadirection := -1


var fallaccel := 25
var fallspeed_max := 400

var displayname := "? ? ? ?" 
var team:= "enemy"
@export var hp:= 10
var hp_max:= 10
@export var deathgraphics:Array[String] = ["explosion"] #explosion;toss

var realscale := 1.0

#don't need to change these
var state_called:Array[String] = [] #used to fix states not being called after state changes because of ordering



func _ready():
	process_priority = 100

##this method won't happen because any inheritor will replace it with their own physics process
##use this as a copypaste you build enemy behavior off later 
func _physics_process(delta):
	defaultbehavior()


##Mika doesn't use this, but all the enemies probably should.
func defaultbehavior():
	tickframe()
	if hitstop == 0:
		if invulntimer > 0: invulntimer-=1
		move_and_slide()
		gravity()
		update_animation()
		detect_mika()
		uniquebehavior()
		state_called = []

#this should be replaced in the inherited script for custom behavior like the state machine. 
func uniquebehavior():
	pass

#hitbox/hurtbox logic

##Creates a hitbox, with its parameters defined by the p Dictionary.
##Making it a dict can make code way faster, as you don't have to specify every single
#useful parameter and can simply define the relevant ones while deferring to the default values.
##Optional variables don't have the same effect due to ordering.


func create_hitbox(p:Dictionary):
	var hitbox = preload('res://Fundamental/Hitbox.tscn').instantiate()
	
	#initialization
	get_parent().add_child(hitbox)
	hitbox.position = position
	hitbox.creator = self
	hitbox.team = team
	hitbox.direction = direction
	hitbox.initial_state = state
	hitbox.created_frame = get_parent().get_parent().gametime

	for x in p:
		if p.has(x):
			hitbox.set(x,p[x])
	#weirder edge cases
	if not p.has("hitstop_dealt"):
		hitbox.hitstop_dealt = int ( hitbox.damage / 3 ) + 4
	if p.has("animation"):
		hitbox.get_node("sprite").animation = p['animation']
	elif hitbox.hitboxtype == "melee":
		hitbox.get_node("sprite").visible = false
	

##Replace this in inherited script if you want special code
func gethit():
#flash 

	flashingtimer = 4
	$sprite.modulate = Color(3,3,3,1)
	if hp <= 0:
		die()

func die():
	#fixes hitboxes referencing a creator that don't exist no more
	for x in get_parent().get_children():
		if x is HitBox:
			if x.creator == self and x.hitboxtype == "melee":
				x.queue_free()
	for x in deathgraphics: match x:
		"explosion":
			var explosion := preload("res://Polish/DeathExplode.tscn").instantiate()
			get_parent().add_child(explosion)
			explosion.scale *= $sprite.scale
			explosion.position = $sprite.global_position
		"toss":
			pass
	queue_free()





#state machine logic

func state_caller(): pass #here to be replaced in inheritors

func statecheck(checkedstate:String) -> bool:
	if state == checkedstate:
		if not (state in state_called):
			state_called.append(state)
			return true
		else:
			return false
	else:
		return false

func nstate(newstate:String):
	prevstate = state
	state = newstate
	frame = 0
	update_animation()
	state_caller()


func detect_mika():
	if has_node("MikaDetector"):
		for x in get_node("MikaDetector").get_overlapping_bodies():
			if x.name == "Mika":
				mikadetected = true
				if x.position.x > position.x:
					mikadirection = 1 
				else:
					mikadirection = -1
				return
		mikadetected = false

func update_animation():
	$sprite.play(state)
	$sprite.frame = frame
	if has_node("AnimationPlayer"):$AnimationPlayer.play(state)
	$sprite.scale.x = direction * realscale#yes this isn't perfect. go fuck yourself 
	$sprite.scale.y = realscale
	if flashingtimer > 0:
		$sprite.modulate = Color(2,2,2,1)
		flashingtimer-=1
	else: $sprite.modulate = Color(1,1,1,1)


func tickframe():
	if hitstop > 0: #putting this before frame increment might be a bad idea 
		hitstop -=1
	if hitstop == 0:
		frame+=1


#Usefuls

func gravity(customaccel:int=fallaccel):
	if velocity.y < fallspeed_max:
		velocity.y += customaccel
		if velocity.y > fallspeed_max: velocity.y = fallspeed_max
	
func global_hitstop(length:int):
	get_parent().get_parent().global_hitstop(length)
