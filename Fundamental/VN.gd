extends Node2D

var active := false #if true, then Gameplay node inputs are paused. Might simply erase this node
var currentscene = [
#[0]= command type
#[1]= variable1. Should be text, I don't think we need more vars
	["speaker","Mika"],
	["print","Check out this yoyo trick"],
	["speaker","Normal person"],
	["print","you're just walking the dog ass whole"],
	["speaker","Mika"],
	["print","Why is everybody so mean to me"],
	["print","im so mad im going to drink juice and fuck my wife i feel so mad"],
	["speaker","Normal person"],
	["print","thats paint thinner"],
	

]
var sceneindex := 0 #currentscene list index




var speakercolors:Dictionary = {
	"Mika" : 0xDDBFF8
	
	}




func processline():
	if sceneindex > len(currentscene) - 1:
		queue_free() #replace with anim maybe
		return 
	var command:Array = currentscene[sceneindex]
	var commandname:String = command[0]

	var instantcontinue = true #used for speakers. This will also mean an unknown command will just be skipped

	if commandname == "print":
		printspeech(command[1])
		instantcontinue = false 
	
	if commandname == "speaker":
		speakername(command[1])
		#default speaker color
		if command[1] in speakercolors:
			$speakerbox/label.add_theme_color_override("font_color", Color.hex(speakercolors[command[1]]))
		else:
			$speakerbox/label.add_theme_color_override("font_color", Color(1,1,1,1)) 
	
	
	##Continues scene. Needs to be a separate function for the same frame loop to work 
	continuescene(instantcontinue)


func continuescene(instantcontinue):
	sceneindex+=1
	if instantcontinue:
		processline()


func printspeech(text:String):
	$textbox/label.text = text

func speakername(text:String):
	$speakerbox/label.text = text 

func speakercolor(color): #not sure what type 
	$speakerbox/label.add_theme_color_override("font_color", Color.hex(color)) 



func _ready():
	pass 


func _process(delta):
	if Input.is_action_just_pressed("A"):
		processline()
