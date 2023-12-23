extends Sprite2D

@export var scenename:String = "testvn"
#touch means you only need to collide with it. The object deletes itself after use. 
#pressup means collide and press up on kb. should show a UI thing showing the bound up button
@export var triggertype:String = "touch"
@export var velreset:int = 1000
@export var saveto_playedvns := true

func _ready():
	visible = false
	if scenename in global.gamesave.playedvns:
		queue_free()


func _process(delta):
	for x in $Area2D.get_overlapping_bodies():
		if x.name == "Mika":
			if triggertype == "touch":
				x.momentumreset(velreset)
				x.get_parent().get_parent().createvn(scenename)
				if saveto_playedvns: global.gamesave.playedvns.append(scenename)
				queue_free()
			if triggertype == "uptalk" and x.is_on_floor():
				x.get_node("TextAlert").text = "Press Up To Talk"
				x.get_node("TextAlert").visible = true 
				if x.inputpressed("up"):
					x.get_parent().get_parent().createvn(scenename)

