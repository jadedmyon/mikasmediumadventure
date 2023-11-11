extends Node2D

var fadestate := "visible"


func _ready():
	if global.debug: #launch test
		pass
	else: #go to title screen as normal 
		pass

func _process(delta):
	if fadestate == "fadeout":
		modulate.a -= 0.007
	if modulate.a <= 0:
		queue_free()

