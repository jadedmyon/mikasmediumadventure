extends Node2D




func _ready():
	pass 



func _physics_process(delta):
	if Input.is_action_pressed("Start"): get_tree().reload_current_scene()
	debug()
	buffer_processing()
	gametime+=1 
	$Camera2D.position = get_node("Entities/Mika").position


func debug():
	var mika = get_node("Entities/Mika")
	$CanvasLayer/DebugText.text = "state- " + str(mika.state) + "\nframe- " + str(mika.frame) \
	+ "\nvelocity- " + str(mika.velocity) + "\nhitstop " + str(mika.hitstop)


func global_hitstop(length:int):
	for x in get_node("Entities").get_children():
		if not x.get("hitstop") == null:
			x.hitstop = length
		


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
	for key in buffer: if key == input:
		if buffer[key][0] > 0:
			return true
		else:
			return false
	print ("Key doesn't exist??? What the fuck")
	return false

func inputpressed(input,buffernum:int=standardbuffer,erase=true) -> bool: #erase makes the input unbufferable. 
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
	



