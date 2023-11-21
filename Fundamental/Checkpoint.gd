class_name CheckPoint extends Area2D



func _ready():
	pass



func _process(delta):
	for x in get_overlapping_bodies(): if x.name == "Mika":
		if x.hp < x.hp_max: x.heal_full()
		savegame()


func savegame():
	global.gamesave.checkpointlevel = get_parent().get_parent().currentlevel
	
