extends AnimatedSprite2D

var creator = null 


var actionframe := 0
var endframe := 70
var passeddown_params:Dictionary = {}

func _ready():
	sfx("delayedattack-start",-9,0.8)



func _process(delta):
	
 
	actionframe +=1
	modulate.a = 1 - (float(actionframe) / float(endframe)) 
	if actionframe == endframe -1:

		create_hitbox(passeddown_params)
	if actionframe >= endframe:
		queue_free()





func create_hitbox(p:Dictionary):
	sfx("delayedattack-blow",-6)
	
	
	var hitbox = preload('res://Fundamental/Hitbox.tscn').instantiate()
	
	#initialization
	get_parent().add_child(hitbox)
	hitbox.position = position
	hitbox.creator = null
	
	hitbox.team = "enemy"
#	hitbox.initial_state = state #could be used for delayed melee attacks(????) but why 
	hitbox.created_frame = get_parent().get_parent().gametime

	for x in p:
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




func sfx(soundname:String,sfxvolume:float=0,pitch:float = 1.0):
	var sfxnode := preload("res://Fundamental/SFX.tscn").instantiate()
	var soundused := load('SFX/' + soundname + ".wav") 
	get_parent().add_child(sfxnode)
	sfxnode.position = position
	sfxnode.pitch_scale = pitch
	sfxnode.stream = soundused
	sfxnode.volume_db = sfxvolume
	sfxnode.play()
