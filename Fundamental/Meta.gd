extends Node2D



func createvn(scenename:String):
	var VN = preload('res://Fundamental/VN.tscn').instantiate()
	if $CanvasLayer.has_node("VN"):
		var oldvnnode = get_node("CanvasLayer/VN")
		oldvnnode.name = "VN-to-be-deleted"
		oldvnnode.queue_free()
	get_node("CanvasLayer").add_child(VN)
	VN.loadscene(scenename)


func newgame():
	get_node("TitleScreen").fadestate = "fadeout"
	createvn("opening")

func titlescreen_bad():
	var titlescreen:= preload("res://Fundamental/TitleScreen.tscn").instantiate()
	add_child(titlescreen)
	titlescreen.position = Vector2(-640,-360)
	createvn("titlescreen")

func titlescreen():
	get_tree().reload_current_scene()

func _ready():
	createvn("titlescreen")
	playmusic("titlescreen")
#	playmusic("ys3-theboywhohadwings")







				#MUSIC

##When music is played, a thingie shows up in the bottom of the screen that tells you the track name 
var musicnames:Dictionary = {
	"mikamansion" : "Ys III- The Boy Who Had Wings by Falcom",
	"titlescreen" : "vghjfkkgj" ,
	
	}

func stopmusic():
	$Music.stream = null
	$Music.stop()

##Assumes it's an ogg file. You SHOULD be assuming that. OGG is great. Do not use not OGG for game music
func playmusic(musicname:String,musicvolume:float=-10):
	$Music.stop()
	var musicused = load('Music/' + musicname + ".ogg")
	
	$Music.stream = musicused
	$Music.volume_db = musicvolume
	$Music.play()
	promptmusicname(musicname)

func promptmusicname(musicname:String):
	var showntext:String = musicnames[musicname]
	
