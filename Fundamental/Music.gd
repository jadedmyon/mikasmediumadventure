extends AudioStreamPlayer

var looping := true


func _process(delta):
	if !playing and looping:
		play()
