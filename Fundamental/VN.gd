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

var dialogueoptions:Array = []
var dialogueselected := -1 #array index. -1 by default so you don't accidentally continue.
var dialoguepositions:Array[Vector2] = [] #For rendering the text 


var speakercolors:Dictionary = {
	"Debut Mika" : 0xDDBFF8,
	"Mika" : 0xDDBFF8,
	}




func processline():
	if sceneindex > len(currentscene) - 1: #if the scene ends
		end()
		return 
	var command:Array = currentscene[sceneindex]
	var commandname:String = command[0]

	var instantcontinue = true #if false, the loop will end. Only rly happens w/ print

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
		icon(command[1])
	if commandname in ["icon"]:
		icon(command[1])
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
	if commandname == "jump":
		jump(command[1])
	
	
	if commandname == "loadlevel":
		var posid = "0"
		if len(command) > 2: posid = command[2]
		loadlevel(command[1],posid)
	
	if commandname == "choice":
		dialogueoptions.append([  command[1],command[2]     ])

	if commandname == "end":
		end()
	if commandname == "die":
		end() #placeholder
	##Continues scene. Needs to be a separate function for the same frame loop to work(?)
	continuescene(instantcontinue)


func continuescene(instantcontinue):
	sceneindex+=1
	if instantcontinue:
		processline()


func printspeech(text:String):
	$textbox/label.text = text
	if dialogueoptions != []:
		renderchoices()

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

func icon(animname:String):
	$iconbox.visible = true
	$icon.visible = true
	if $icon.sprite_frames.has_animation(animname):
		$icon.animation = animname

func renderchoices():
	$OptionsText.visible = true
	$OptionsText.text = "\n"
	var current_dialoguepos = 0
	
	for x in dialogueoptions:
		dialoguepositions.append( $OptionsText.position + Vector2(0,$OptionsText.get_content_height()))
		var lineposition:Vector2 =  $OptionsText.position + Vector2(0,$OptionsText.get_content_height())
		create_choicemarker( lineposition  +\
		Vector2(-26,($OptionsText.get_theme_font_size("normal_font_size") / 1.5 )), current_dialoguepos)
		$OptionsText.get_theme_font_size("normal_font_size") /2 
		$OptionsText.append_text(x[0])
		$OptionsText.append_text("\n\n")
		
		#end
		current_dialoguepos+=1
	#update optionsbox
	$OptionsBox.visible = true
	var contentsize := Vector2($OptionsText.get_content_width(),$OptionsText.get_content_height())
	$OptionsBox.size = contentsize + Vector2(64,24)
	


func create_choicemarker(pos:Vector2,dialoguepos:int):
	var choicemarker := preload("res://Polish/ChoiceMarker.tscn").instantiate()
	add_child(choicemarker)
	choicemarker.position = pos
	choicemarker.dialoguepos = dialoguepos


func jump(flagname:String):
	for x in len(currentscene):
		if currentscene[x][0] == "flag":
			if currentscene[x][1] == flagname:
				sceneindex = x
				processline()
				return

func end():
	queue_free()

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

func PlayerInput():
	if dialogueoptions == []:
		processline()
	else:

		if dialogueselected in range(len(dialogueoptions)):
			var flag:String = dialogueoptions[dialogueselected][1]
			dialogueoptions = []
			$OptionsText.text = ""
			$OptionsBox.visible = false
			$OptionsText.visible = false
			dialogueselected = -1
			jump(flag)
			




func _process(delta):
	if dialogueoptions != []:
		var lastoption = len(dialogueoptions)-1
		if Input.is_action_just_pressed("down"):
			if dialogueselected == -1:
				dialogueselected = 0
			elif dialogueselected != lastoption:
				dialogueselected+=1
		if Input.is_action_just_pressed("up"):
			if dialogueselected == -1:
				dialogueselected = lastoption
			elif dialogueselected != 0:
				dialogueselected-=1
	
	
	if Input.is_action_just_pressed("B"):
		PlayerInput()
