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
	["speakercolor",0xc3f9fb],
	["print","thats paint thinner"],
	["addscene","testvn"],
	
]
var sceneindex := 0 #currentscene list index




var speakercolors:Dictionary = {
	"Debut Mika" : 0xDDBFF8,
	"Mika" : 0xDDBFF8,
	}




func processline():
	if sceneindex > len(currentscene) - 1:
		queue_free() #replace with anim maybe
		return 
	var command:Array = currentscene[sceneindex]
	var commandname:String = command[0]

	var instantcontinue = true #used for speakers. This will also mean an unknown command will just be skipped

	if commandname in ["print","p"]:
		printspeech(command[1])
		instantcontinue = false 

	if commandname in ["speaker","s"]:
		speakername(command[1])
		#default speaker color
		if command[1] in speakercolors:
			$speakerbox/label.add_theme_color_override("font_color", Color.hex(speakercolors[command[1]]))
		else:
			$speakerbox/label.add_theme_color_override("font_color", Color(1,1,1,1)) 
	if commandname in ["icon"]:
		pass
	if commandname in ["speakertext","st"]:
		speakername(command[1])
	if commandname in ["speakercolor","sc"]:
		speakercolor(command[1])
	if commandname in ["addscene"]:
		addscene(command[1])
	if commandname in ["hidespeaker","hs"]:
		hidespeaker()
	if commandname in ["hidespeakerbox", "hsb"]:
		hidespeakerbox()
	if commandname in ["hideicon","hi"]:
		hideicon()
	if commandname == "shadowspeaker":
		speakername(command[1])
		#default speaker color
		if command[1] in speakercolors:
			$speakerbox/label.add_theme_color_override("font_color", Color.hex(speakercolors[command[1]]))
		else:
			$speakerbox/label.add_theme_color_override("font_color", Color(1,1,1,1)) 
		hideicon()
	if commandname == "loadlevel":
		var posid = "0"
		if len(command) > 2: posid = command[2]
		loadlevel(command[1],posid)
	
	##Continues scene. Needs to be a separate function for the same frame loop to work(?)
	continuescene(instantcontinue)


func continuescene(instantcontinue):
	sceneindex+=1
	if instantcontinue:
		processline()


func printspeech(text:String):
	$textbox/label.text = text

func speakername(text:String):
	$speakerbox.visible = true 
	$speakerbox/label.text = text 

func speakercolor(color):
	$speakerbox.visible = true 
	$speakerbox/label.add_theme_color_override("font_color", Color.hex(int(color))) 

func hidespeakerbox():
	$speakerbox.visible = false
	

func hidespeaker():
	hidespeakerbox()
	hideicon()


func hideicon():
	$iconbox.visible = false
	$icon.visible = false




func loadlevel(levelname:String,posid:String):
	get_parent().get_parent().get_node("Gameplay").levelswitch(levelname,int(posid))

func addscene(scenename:String):

	
	var loadfile = FileAccess.open('res://VNScenes/' + scenename + '.mikascene', FileAccess.READ)

	var splitperline = loadfile.get_as_text().split("\r\n")
	for line in splitperline:
		var linesplit:Array = line.split(";")
		var commandname:String = linesplit[0]
		if len(linesplit) == 1: #regular print line
			currentscene.append(["print",linesplit[0]])
		elif commandname != "" and commandname[0] != "#":
			currentscene.append(linesplit)
	
	loadfile.close() 

func loadscene(scenename:String):
	currentscene = []
	addscene(scenename)
	processline()



func _ready():
	
	pass


func _process(delta):
	if Input.is_action_just_pressed("B"):
		processline()
