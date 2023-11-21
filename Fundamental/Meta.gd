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
	createvn("opening")

func continuegame():
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
	get_tree().reload_current_scene()

func _ready():
	createvn("titlescreen")
#	playmusic("titlescreen")







				#MUSIC

##When music is played, a thingie shows up in the bottom of the screen that tells you the track name 
var musicnames:Dictionary = {
	"mikamansion" : "Ys III- The Boy Who Had Wings by Falcom",
	"titlescreen" : "vghjfkkgj" ,
	"death" : "Original- Mika Fuckign Dies by jadedmyon",
	"sleep" : "Elona- Dungeon 1 song",
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
