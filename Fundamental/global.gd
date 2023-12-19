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
	
	
	playedvns = [], #filenames
	
	#Difficulty related
	difficulty = 1, #1= Normal, 2= Mika
	deaths = 0,
	ninebuttonuses = 0,
	mikaquestionasked = false,

	ennatruthed = false,
	debutmika2talked = false,
	debutmika6losses = 0,

	}

#copies gamesave on boot if this is empty
var gamesave_default:Dictionary = {}

func wipesave():
	gamesave = gamesave_default.duplicate() 

func _ready():
	pass 


func _process(delta):
	pass
