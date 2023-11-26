extends Sprite2D
#This SPAMS the sound effect!!
#Was completely unintentional but ended up working in the Mansion level for the creepy factor kind of
#for single sfx you can use the VN system and set velreset to 0

@export var sfxname:String = ""
@export var sfxvolume:int = 0

func _ready():
	visible = false



func _process(delta):
	for x in $Area2D.get_overlapping_bodies():
		if x.name == "Mika":
			x.sfx(sfxname,sfxvolume)
