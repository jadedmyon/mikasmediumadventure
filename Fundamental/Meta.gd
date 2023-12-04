extends Node2D



func createvn(scenename:String):
	var VN = preload('res://Fundamental/VN.tscn').instantiate()
	deletevn()
	get_node("CanvasLayer").add_child(VN)
	VN.loadscene(scenename)

func deletevn():
	if $CanvasLayer.has_node("VN"):
		var oldvnnode = get_node("CanvasLayer/VN")
		oldvnnode.name = "VN-to-be-deleted"
		oldvnnode.queue_free()

func newgame():

	get_node("TitleScreen").fadestate = "fadeout"
	global.wipesave()
	
	createvn("opening")

func continuegame():
	if has_node("TitleScreen"):
		get_node("TitleScreen").queue_free()
	if global.gamesave.checkpointlevel == "":
		newgame()
		return
	
	var gameplaynode := get_node("Gameplay")
	gameplaynode.loadlevel(global.gamesave.checkpointlevel,685)
	if global.gamesave.latestmusic != "": playmusic(global.gamesave.latestmusic,global.gamesave.latestmusic_volume)
	deletevn()


func titlescreen_bad():
	var titlescreen:= preload("res://Fundamental/TitleScreen.tscn").instantiate()
	add_child(titlescreen)
	titlescreen.position = Vector2(-640,-360)
	createvn("titlescreen")

func titlescreen():
	get_tree().reload_current_scene() #lmao

func _ready():
	sfx("mimkatitel")
	if global.gamesave_default == {}: #meant to be used for ghdfsjklbhnsdlfsbigdbkidibkidikbdsahds
		global.gamesave_default = global.gamesave.duplicate() 
	get_node("Gameplay/CanvasLayer/enemyinfo").visible = false
	loadsave()
	createvn("titlescreen")


#	playmusic("titlescreen")







				#MUSIC

##When music is played, a thingie shows up in the bottom of the screen that tells you the track name 
var musicnames:Dictionary = {
	"mikamansion" : "Elona- Arena theme by noacat",
	"titlescreen" : "vghjfkkgj by phlkhbkllk" ,
	"death" : "Original- Mika Fuckign Dies by jadedmyon",
	"sleep" : "Elona- Dungeon 1 by noacat",
	"debutmika1" : "The Penis (Eek!) by Surasshu",
	}

func stopmusic():
	$Music.stream = null
	$Music.stop()

##Assumes it's an ogg file. You SHOULD be assuming that. OGG is great. Do not use not OGG for game music
func playmusic(musicname:String,musicvolume:float=-10,looping:bool=true):
	$Music.stop()
	
	$Music.looping = looping
	var musicused = load('Music/' + musicname + ".ogg")
	if looping: #prevents death song from being played as BGM 
		global.gamesave.latestmusic = musicname
		global.gamesave.latestmusic_volume = musicvolume
	$Music.stream = musicused
	$Music.volume_db = musicvolume
	$Music.play()
	promptmusicname(musicname)

func promptmusicname(musicname:String):
	var showntext:String = musicnames[musicname]
	if musicname != "titlescreen":
		$CanvasLayer/musicshow.startshow(showntext)


func loadsave():
	var loadfile = FileAccess.open('res://gamesave.txt', FileAccess.READ)
	if not FileAccess.file_exists('res://gamesave.txt'):
		var saveasjson =  JSON.stringify(global.gamesave_default.duplicate())
		var savefile = FileAccess.open('res://gamesave.txt', FileAccess.WRITE)
		savefile.store_string(saveasjson)
	else:
		var parsed_json = JSON.parse_string(loadfile.get_as_text())
		global.gamesave = {}
		global.gamesave = parsed_json.duplicate()

		loadfile.close() 

func sfx(soundname:String,sfxvolume:float=0,pitch:float = 1.0):
	var sfxnode := preload("res://Fundamental/SFX.tscn").instantiate()
	var soundused := load('SFX/' + soundname + ".wav") 
	add_child(sfxnode)
	sfxnode.stream = soundused
	sfxnode.pitch_scale = pitch
	sfxnode.volume_db = sfxvolume
	sfxnode.play()
