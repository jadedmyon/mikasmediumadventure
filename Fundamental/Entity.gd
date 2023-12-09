class_name Entity extends CharacterBody2D

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

@export var displayname := "? ? ? ?" 
var team:= "enemy"
@export var hp:= 10
var hp_max:= 0
var deathgraphics:Array[String] = ["explosion"] #explosion;toss
var deathtype := "normal" #normal, forceddeath, standup
var hitsound := "hit1"
var hitvolume := -10.0
var show_info := true
var boss : = false


@export var realscale := 1.0
var updateanimation := true

#don't need to change these
var state_called:Array[String] = [] #used to fix states not being called after state changes because of ordering
var currentstatedamage := 0 #used for bosses
var vulnerable: = false #if true then go to hitstun state 
var damagetaken_mult = 1.0 

func _ready():
	process_priority = 100


##Do not replace this, use uniquebehavior() instead 
func _physics_process(delta):
	defaultbehavior()


##Mika doesn't use this, but all the enemies probably should.
func defaultbehavior():
	tickframe()
	if hp_max == 0: hp_max = hp
	if hitstop == 0:
		if invulntimer > 0: invulntimer-=1
		move_and_slide()
		gravity()
		update_animation()
		detect_mika()
		uniquebehavior()
		state_caller()
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
	if p.has("polygonscale"):
		hitbox.get_node("CollisionPolygon2D").scale = p['polygonscale']
	if p.has("everythingoffset"): #this is dumb bullshit I didn't test
		for x in hitbox.get_children():
			x.position.x += p["everythingoffset"]
	if not p.has("hitstop_dealt"):
		hitbox.hitstop_dealt = int ( hitbox.damage / 3 ) + 5
	if p.has("animation"):
		hitbox.get_node("sprite").animation = p['animation']
	elif hitbox.hitboxtype == "melee":
		hitbox.get_node("sprite").visible = false

func create_delayedhitbox(
	
	endframe:int=40,
	dhitbox_scale:Vector2=Vector2(6,6),
	dhitbox_pos:Vector2 = mikahurtboxpos(),

p:Dictionary={
	hitboxtype = "projectile", speedX = 0, speedY = 0, animation = "delayedprojectile",
	destroyontilemap = false,
	damage = 6, duration = 46,
	scale = Vector2(6,6), fadeoutspeed = 0.022,
	
	
}):
	
	var dhitbox := preload("res://Fundamental/DelayedAttack.tscn").instantiate()
	get_parent().add_child(dhitbox)
	dhitbox.creator = self
	dhitbox.endframe = endframe
	dhitbox.scale = dhitbox_scale
	dhitbox.position = dhitbox_pos
	dhitbox.passeddown_params = p


func mikacollision_bounce():

	for x in $Hurtbox.get_overlapping_bodies():
		if x.name == "Mika" and x.position.y > position.y + 50:
			var relative := 1 #1 or =1, depends on where mika x is
			if x.position.x > position.x: relative = -1
			var rngy := randi() % 10
			var rngx := randi() % 4
			var rngrotation := randi() % 30
			velocity.y -= 100 + 30 * rngy
			velocity.x += relative * 100 * (rngx+1)
			rotation_degrees += rngrotation

##Replace this in inherited script if you want special code
func gethit():
#flash 
	flashingtimer = 4
	sfx(hitsound,hitvolume,1)
	$sprite.modulate = Color(3,3,3,1)
	if show_info: update_enemyinfo()
	if hp <= 0:

		die()



func update_enemyinfo(enemyused=self):
	get_parent().get_parent().shownenemy = enemyused
	get_parent().get_parent().update_enemyinfo()


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



func heal_full():
	heal(hp_max-hp)

func heal(healamount:int):
	var healthbefore := hp
	hp = min(hp_max,hp+healamount)
	var healed := hp - healthbefore
	var healtext := preload("res://Polish/DamageText.tscn").instantiate()
	get_parent().add_child(healtext)
	var rng := randi() % 5
	var rngX := randi() % 5
	healtext.position = position + Vector2(5 * rngX,-30 - (10 *rng))
	healtext.text = "+" +  str(healed)
	healtext.add_theme_color_override("font_color", Color(0.05,0.95,0.2))

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
	currentstatedamage = 0
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
	if updateanimation: $sprite.frame = frame
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play(state)

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


func sfx(soundname:String,sfxvolume:float=0,pitch:float = 1.0):
	var sfxnode := preload("res://Fundamental/SFX.tscn").instantiate()
	var soundused := load('SFX/' + soundname + ".wav") 
	get_parent().add_child(sfxnode)
	sfxnode.position = position
	sfxnode.pitch_scale = pitch
	sfxnode.stream = soundused
	sfxnode.volume_db = sfxvolume
	sfxnode.play()



	#bosses mostly use this


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


func createvn(scenename:String):
	var VN = preload('res://Fundamental/VN.tscn').instantiate()
	get_parent().get_parent().get_parent().get_node("CanvasLayer").add_child(VN)
	VN.loadscene(scenename)



#Usefuls

func gravity(customaccel:int=fallaccel):
	if velocity.y < fallspeed_max:
		velocity.y += customaccel
		if velocity.y > fallspeed_max: velocity.y = fallspeed_max
	
func global_hitstop(length:int):
	get_parent().get_parent().global_hitstop(length)


##Changes non-absolute velocity in given direction with an absolute maximum
func xvelocity_towards(addedvel:int,maximum):
	var sign = abs(addedvel) / addedvel
	if abs(velocity.x) > maximum: return
	velocity.x += addedvel
	if abs(velocity.x) > maximum:
		velocity.x = maximum * sign

func momentumreset(momentum): #like traction/friction but w a custom value
	var initialspeed = velocity.x
	if initialspeed > 0: 
		velocity.x -= momentum
		if velocity.x < 0: velocity.x = 0
	else:
		velocity.x += momentum
		if velocity.x > 0: velocity.x = 0
