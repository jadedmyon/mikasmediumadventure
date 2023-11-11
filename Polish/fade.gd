extends Sprite2D

#visible (gameplay is visible)
#black (black screen)
#fadein (from black to visible)
#fadeout (from visible to black)
var state := "black"

var fadespeed := 0.01

func _ready():
	visible = true

func _process(delta):
	match state:
		"fadein":
			modulate.a -= fadespeed
			if modulate.a <= 0: state = "visible"
		"fadeout":
			modulate.a+= fadespeed
			if modulate.a >= 1: state = "black"
		

