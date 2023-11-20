extends Sprite2D

var actionframe := 0
var state := "idle"

func _ready():
	pass # Replace with function body.


func _process(delta):
	
	actionframe +=1
	match state:
		"fadein":
			modulate.a += 0.006
			if modulate.a >= 1:
				nstate("hold")
		"hold":
			if actionframe == 300:
				nstate("fadeout")
		"fadeout":
			modulate.a -= 0.007
			if modulate.a <= 0:
				nstate("invisible")
			


func nstate(newstate:String):
	state = newstate
	actionframe = 0

func startshow(newtext:String):
	modulate.a = 0.001
	nstate("fadein")
	$Label.text = newtext
