extends Node2D

var currentlevel = "MansionStart" #used to save level names when saving at checkpoints 

##For levels to work correctly, the level node MUST be named Entities.
#No entity/hitbox that's expected to follow basic rules like hitstop should be a child of another entity.
#Hitboxes and TileMap are also direct children of Entities node. 
func loadlevel(levelname:String,posid:int):
	var entitiesnode = load("res://Levels/" + levelname +".tscn").instantiate()
	currentlevel = levelname
	if has_node("Entities"): #delete existing entities node first
		var oldentities = get_node("Entities")
		oldentities.name = "AwfulEntities"
		oldentities.visible = false
		oldentities.queue_free() #this used to be a free() but it crashed too often with no discernible reason
	add_child(entitiesnode)
			#Instantiate Mika
	var mika = preload('res://Fundamental/Mika.tscn').instantiate()
	entitiesnode.add_child(mika)
	loadstats()
		#Find position
	var pos:Vector2 = Vector2(-9999999,-9999999) #default value to control for positionid not existing
	if posid == 685: #685 is used for skipping to checkpoint instead
		for x in entitiesnode.get_children():
			if x is CheckPoint:
				pos = x.position
				break
	else:
		for x in entitiesnode.get_children():
			if x is PositionMarker:
				if x.positionid == posid:
					pos = x.position
					break
				if pos == Vector2(-9999999,-9999999) and x.positionid == 0: #if positionid doesn't exist for some reason
					pos = x.position #no break because it'll be overwritten by a real position
	
	mika.position = pos
	$CanvasLayer/enemyinfo.visible = false


##To be replaced later with maybe a fadeout effect?
func levelswitch(levelname:String,posid:int):
	if has_node("Entities/Mika"): savestats()
	loadlevel(levelname,posid)

const savedstatnames:Array[String] = ["hp","hp_max","meter","meter_max","exp","level","direction"]



func savestats():
	var mika = get_node("Entities/Mika")

	for x in savedstatnames:
		global.gamesave[x] = mika.get(x)


func loadstats():
	var mika = get_node("Entities/Mika")
	for x in savedstatnames:
		mika.set(x,global.gamesave[x])


func createvn(scenename:String):
	var VN = preload('res://Fundamental/VN.tscn').instantiate()
	get_parent().get_node("CanvasLayer").add_child(VN)
	VN.loadscene(scenename)




func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("Start"): get_tree().reload_current_scene()
	debug()
	buffer_processing()
	gametime+=1
	if has_node("Entities"):
		$Camera2D.position = get_node("Entities/Mika").position + Vector2(0,-100)

	if $CanvasLayer/enemyinfo/HP.text == "0":
		$CanvasLayer/enemyinfo.modulate.a -= 0.01


func debug():
	if has_node("Entities"):
		var mika = get_node("Entities/Mika")
		$CanvasLayer/DebugText.text = "state- " + str(mika.state) + "\nframe- " + str(mika.frame) \
		+ "\nvelocity- " + str(mika.velocity) + "\nhitstop " + str(mika.hitstop) + \
		"\nhp " + str(mika.hp) + "/" + str(mika.hp_max)
		
		$CanvasLayer/PlaceholderDisplay.text = \
		"HP     " + str(mika.hp) + "/" + str(mika.hp_max)
		

func global_hitstop(length:int):
	for x in get_node("Entities").get_children():
		if not x.get("hitstop") == null:
			x.hitstop = length
		

		##UI
var shownenemy = null #reference to an entity

func update_enemyinfo():
	if shownenemy == null:
		$CanvasLayer/enemyinfo.visible = false
	else:
		$CanvasLayer/enemyinfo.modulate.a = 1
		$CanvasLayer/enemyinfo.visible = true
		
		$CanvasLayer/enemyinfo/Name.text = shownenemy.displayname
		$CanvasLayer/enemyinfo/HP.text = str(max(0,shownenemy.hp))
		$CanvasLayer/enemyinfo/healthbar.value =  (float(shownenemy.hp) / float(shownenemy.hp_max)) * 100 
		



########################
####	##INPUTS	####
########################

var gametime := 0

var replaying := false #not sure if I want to add a replay system since it will only be useful for debugging
var replay = {}

var buffer = {
	#[0] frames the input was held
	#[1] frames since the button was last pressed (standard buffer)
	#[2] frames since the button was last released (negative edge)
	"up" : [0,685685,685685],
	"down" : [0,685685,685685],
	"left" : [0,685685,685685],
	"right" : [0,685685,685685],
	"A" : [0,685685,685685],
	"B" : [0,685685,685685],
	"L" : [0,685685,685685],
	"X" : [0,685685,685685],
	"Start" : [0,685685,685685],
	"ninebutton" : [0,685685,685685],
	}

var standardbuffer:= 5
var edgebuffer := 4


func buffer_processing():
	for key in buffer:
		pass
		buffer[key][1] += 1 #press buffer
		buffer[key][2] += 1 #release buffer
		
		if Input.is_action_pressed(key) and buffer[key][0] == 0: #reset pressbuffer on any new input 
			buffer[key][1] = 0
		
		if Input.is_action_pressed(key): #adds to [0] to store how long a button has been held. Has to be after press buffer set
			buffer[key][0] +=1
		elif buffer[key][0] != 0: #it's been released
			buffer[key][0] = 0
			buffer[key][2] = 0

func inputheld(input) -> bool:
	if get_parent().get_node("CanvasLayer").has_node("VN"): #absolutely monstrous 
		return false #no inputs while cutscene happens 
	
	for key in buffer: if key == input:
		if buffer[key][0] > 0:
			return true
		else:
			return false
	print ("Key doesn't exist??? What the fuck")
	return false

func inputpressed(input,buffernum:int=standardbuffer,erase=true) -> bool: #erase means 1 input = 1 outcome
	if get_parent().get_node("CanvasLayer").has_node("VN"): #the fact I have 2 canvas layers is kinda fucked up
		return false #no inputs while cutscene happens 

	for key in buffer: if key == input: #Useful for preventing one input doing two things at once
		if buffer[input][1] < buffernum:
			if erase: buffer[input][1] = buffernum
			return true
		else:
			return false 
	print ("Key doesn't exist??? What the fuck")
	return false

#this is an "instant" release check, I'll finish this if this ends up useful
#if you want to check if a button isn't held at all this frame then just do !inputheld()
func inputreleased(input,buffernum:int=edgebuffer, erase=true):
	if get_parent().get_node("CanvasLayer").has_node("VN"): 
		return false #no inputs while cutscene happens 
	for key in buffer: if key == input:
		pass

#Returns the direction you're holding on the "control stick" with numpad notation 
#not sure about implementing a whole motionqueue system like SF/KoF yet,
#if that ends up being necessary I'll change this to return the latest direction in the queue
func direction_held(direction:int=1) -> String:
	var result := ""
	if inputheld("left") and not inputheld("right"):
		if inputheld("down"): result = "1"
		if inputheld("up"): result = "7"
		if !inputheld("down") and !inputheld("up"): result = "4"
	elif inputheld("right") and not inputheld("left"):
		if inputheld("down"): result = "3"
		if inputheld("up"): result = "9"
		if !inputheld("down") and !inputheld("up"): result = "6"
	#the rest of this happens if both or neither left/right are held
	elif inputheld("down"): result = "2"
	elif inputheld("up"): result = "8"
	else: result = "5"
	
	if direction == 1: return result
	else:
		return flip_direction(result) #flip it 

func flip_direction(input:String) -> String:
	var result = input #2 5 and 8
	match input:
		"1": result = "3"
		"3": result = "1"
		"4": result = "6"
		"6": result = "4"
		"7": result = "9"
		"9": result = "7"
	return result
	

