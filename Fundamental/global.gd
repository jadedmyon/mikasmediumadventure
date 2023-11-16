extends Node

var debug := true

var levelsettings = { 
	#0= 
	#1= default fade status
	"testmansion" : [],
	
	}


var gamesave:Dictionary = {
	
	
	
	difficulty = 0, #0= Mika, 1= Easy, 2= Normal
	
	##0= No attacking. 1= three hit combo + hammer, 2= Water bucket projectile
	nextlevel = "testmansion",
	nextposid = 0,
	progression = 0,
	
	#Saved stats when switching levels
	hp = 80,
	hp_max = 80,
	meter = 0,
	meter_max = 100,
	exp = 0,
	level = 1,
	
	
	mikaquestionasked = false,
	
	}

#copies gamesave on boot if this is empty
var gamesave_default:Dictionary = {}

func _ready():
	pass 


func _process(delta):
	pass
