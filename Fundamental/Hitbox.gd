class_name HitBox extends Area2D

var creator = null #reference
var team := "enemy"
var direction := 1
var initial_state := "penis" #the state the creator was in when the hitbox was made
var created_frame := 0 #global frametime. Not used for anything 
var already_hit = [] #list of entities this hitbox already hit 
var velocity = Vector2(0,0)


var frame := 0
var hitstop := 0

#definable parameters
var duration:=15
var damage:= 8

var hitboxtype:= "melee" #melee is attached to the creator, projectile travels on its own
var hitsleft = 99 #how many times before destroyed 
var offset := Vector2(0,0) #not the best way to implement hitboxes tracking owners, better way would be paths ig
var speedX := 0.0
var speedY := 0.0
var fallaccel:= 0.0
var velocitytowardmika = 0.0
var angle := 0.0
var anglevelocity := 0.0
var speedscale :=  1.0
var invulntimer := 120
var launchdirection := 0 #0 is default behavior 
var adjustanglevisual = "no" #no, onstart, always

var deathtype = "normal" #for bosses, forced hp = 0 on Debut Mika I and forced get up on Debut Mika VI 


var destroyontilemap := true


var hitstop_dealt := 3
# Called when the node enters the scene tree for the first time.
func _ready():
	process_priority = 10
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hit_process()
	if hitboxtype == "melee":
		position = creator.position + Vector2(offset.x*creator.direction , offset.y)
		if initial_state != creator.state: queue_free() #if you get hit or slide off, delete hitbox 
	if hitboxtype == "projectile":
		if frame == 0:
			position+= offset
			velocity.x = speedX * direction
			velocity.y = speedY 
			
			if velocitytowardmika > 0:
				if angle == 0:
					velocity +=  (mikahurtboxpos() - position ).normalized() * velocitytowardmika
				elif anglevelocity == 0: #All of this is broken
					var normals = ( Vector2(cos(deg_to_rad(angle)), sin(deg_to_rad(angle))) + (mikahurtboxpos() - position ).normalized() ).normalized() #wtf
					velocity += normals * velocitytowardmika
				else:
					velocity +=  (mikahurtboxpos() - position ).normalized() * velocitytowardmika
			if (anglevelocity != 0):
				var normal = Vector2(cos(deg_to_rad(angle)), sin(deg_to_rad(angle)))
				velocity+= normal * anglevelocity
				
		velocity.y += fallaccel * speedscale
		
		if destroyontilemap and frame > 5:
			for x in get_overlapping_bodies():
				if x is TileMap:
					queue_free()
		if (frame == 0 and adjustanglevisual == "onstart") or adjustanglevisual == "always":
			anglevisual()
		

	
	
	position += velocity * speedscale
	
	
	
	if frame >= duration:
		queue_free()
	tickframe()
	
	if hitsleft <= 0: queue_free()

func anglevisual():
	rotation = deg_to_rad(angle)

func findmika() -> Node:
	for x in get_parent().get_children():
		if x.name == "Mika":
			return x
	return null

func mikahurtboxpos() -> Vector2:
	return findmika().get_node("Hurtbox").global_position

func hit_process():
	for x in get_overlapping_areas():
		if x.name == "Hurtbox":
			var entity = x.get_parent()
			if entity.team != team and (not entity in already_hit) and ( entity.invulntimer == 0):
				var finaldamage = int( damage * entity.damagetaken_mult )
				already_hit.append(entity)
				entity.deathtype = deathtype
				entity.global_hitstop(hitstop_dealt)
				if !entity.name == "Mika":
					entity.hitstop+= hitstop_dealt
					if entity.vulnerable:
						finaldamage*= 1.5
						entity.nstate("hitstun")

				elif true: #placeholder for when I planned two different hitstun states for mika ignore ignore escapE ESCAPE 
					if launchdirection != 0: entity.direction = launchdirection
					entity.nstate("hitstunair")
					entity.invulntimer = invulntimer #120 default
				entity.hp -= finaldamage
				entity.currentstatedamage += finaldamage
				entity.gethit()
				hitsleft -= 1
				#damage values
				var damagetext := preload("res://Polish/DamageText.tscn").instantiate()
				get_parent().add_child(damagetext)
				var rng := randi() % 5
				var rngX := randi() % 5
				damagetext.position = entity.position + Vector2(5 * rngX,-30 - (10 *rng))
				damagetext.text = "-" +  str(finaldamage)
				
				if entity.name == "Mika":
					damagetext.scale *= 1.5
					damagetext.fadespeed = 0.01
					damagetext.add_theme_color_override("font_color", Color(1,0.1,0.2))

func tickframe():
	if hitstop == 0:
		frame+=1
	if hitstop > 0:
		hitstop -=1
