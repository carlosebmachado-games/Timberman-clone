extends Node2D

onready var man = $man
onready var camera = $camera

func _input(event):
	event = camera.make_input_local(event)
	if event.is_pressed():
		if event.position.x < 360:
			man.to_left()
		else:
			man.to_right()
		man.to_cut()
