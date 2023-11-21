extends Node

var debug := true

var levelsettings = { 
	#0= 
	#1= default fade status
	"testmansion" : [],
	
	}


var gamesave:Dictionary = {
	
	
	

	

	checkpointlevel = "",
	latestmusic = "",
	latestmusic_volume = 0,
	progression = 0, #0= No attacking. 1= three hit combo + hammer, 2= Water bucket projectile
	
	#Saved stats when switching levels
	hp = 80,
	hp_max = 80,
	meter = 0,
	meter_max = 100,
	exp = 0,
	level = 1,
	direction = 1,
	
	
	
	#Difficulty related
	difficulty = 2, #0= Mika, 1= Easy, 2= Normal
	ninebuttonuses = 0,
	mikaquestionasked = false,
	ismika = false,

	}

#copies gamesave on boot if this is empty
var gamesave_default:Dictionary = {}

func _ready():
	pass 


func _process(delta):
	pass
