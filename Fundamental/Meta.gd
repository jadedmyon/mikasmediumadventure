extends Node2D



func createvn(scenename:String):
	var VN = preload('res://Fundamental/VN.tscn').instantiate()
	if $CanvasLayer.has_node("VN"):
		var oldvnnode = get_node("CanvasLayer/VN")
		oldvnnode.name = "VN-to-be-deleted"
		oldvnnode.queue_free()
	get_node("CanvasLayer").add_child(VN)
	VN.loadscene(scenename)


func newgame():
	get_node("TitleScreen").fadestate = "fadeout"
	createvn("opening")

func titlescreen():
	var titlescreen:= preload("res://Fundamental/TitleScreen.tscn").instantiate()
	add_child(titlescreen)
	titlescreen.position = Vector2(-640,-360)
	createvn("titlescreen")

func _ready():
	createvn("titlescreen")
