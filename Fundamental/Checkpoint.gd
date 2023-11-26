class_name CheckPoint extends Area2D



func _ready():
	pass



func _process(delta):
	for x in get_overlapping_bodies(): if x.name == "Mika":
		if x.hp < x.hp_max:
			x.sfx("checkpoint")
			x.heal_full()
		global.gamesave.hp = global.gamesave.hp_max
		savegame()


func savegame():
	global.gamesave.checkpointlevel = get_parent().get_parent().currentlevel
	if global.gamesave.checkpointlevel == "MansionBoss":
		global.gamesave.checkpointlevel = "MansionCheckpoint2"
	
	var savefile = FileAccess.open('res://gamesave.txt', FileAccess.WRITE)
	var save_as_json = JSON.stringify(global.gamesave)
	savefile.store_string(save_as_json)
	savefile.close() 
