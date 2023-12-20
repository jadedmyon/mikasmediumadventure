extends Sprite2D

var actionframe = 0
var endframe = 50
var flickerframe = 5


func _ready():
	visible = false 



func _process(delta):
	if actionframe == endframe:
		visible = true
	
	
	
	if actionframe >= endframe and actionframe < endframe+flickerframe:
		var rngx = randi() % 8
		var rngy = randi () % 8
		position+= Vector2((rngx-4) * 3,rngy-3)
	
	if actionframe == endframe + flickerframe:
		actionframe = 0
		var flickrng = randi() % 5
		flickerframe = 3 + flickrng
		
		var endrng = randi() % 100
		endframe = 30 + endrng
		
		visible = false
	
	actionframe +=1
	
