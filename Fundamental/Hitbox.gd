extends Area2D

var creator = null #reference
var team := "enemy"
var direction := 1
var initial_state := "penis" #the state the creator was in when the hitbox was made
var created_frame := 0 #global frametime. Not used for anything 
var already_hit = [] #list of entities this hitbox already hit 

var frame := 0
var hitstop := 0

#definable parameters
var duration:=5
var damage:= 8

var hitboxtype:= "melee" #melee is attached to the creator, projectile travels on its own
var hitsleft = 99 #how many times before destroyed 
var offset := Vector2(0,0) #not the best way to implement hitboxes tracking owners, better way would be paths ig
var speedX := 10
var speedY := 0

var hitstop_dealt := 3
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hit_process()
	if hitboxtype == "melee":
		position = creator.position + Vector2(offset.x*creator.direction , offset.y)
		if initial_state != creator.state: queue_free() #if you get hit or slide off, delete hitbox 
	if hitboxtype == "projectile":
		position+= Vector2(speedX*direction,speedY)
	
	if frame >= duration:
		queue_free()
	tickframe()
	
	if hitsleft <= 0: queue_free()


func hit_process():
	for x in get_overlapping_areas():
		if x.name == "Hurtbox":
			var entity = x.get_parent()
			if entity.team != team and not entity in already_hit and entity.invulntimer == 0:
				already_hit.append(entity)
				entity.hp -= damage
				entity.global_hitstop(hitstop_dealt)
				if creator.name == "Mika":
					entity.hitstop+= hitstop_dealt
				elif true: #!entity.is_on_floor() #if mika is one getting hit, kinda hacky
					if entity.position.x > 0:
						entity.direction = 1
					else: entity.direction = -1
					entity.nstate("hitstunair")
					entity.invulntimer = 90
				entity.gethit()
				
				hitsleft -= 1

func tickframe():
	if hitstop == 0:
		frame+=1
	if hitstop > 0:
		hitstop -=1
