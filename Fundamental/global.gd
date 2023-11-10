extends Node




var gamesave:Dictionary = {
	
	
	
	difficulty = 0, #0= Mika, 1= Easy, 2= Normal
	
	##0= No attacking. 1= three hit combo + hammer, 2= Water bucket projectile
	nextlevel = "testmansion",
	nextposid = 0,
	progression = 0,
	
	#Saved when switching levels
	hp = 1,
	hp_max = 1,
	meter = 1,
	meter_max = 1,
	
	
	}


func _ready():
	pass 


func _process(delta):
	pass
