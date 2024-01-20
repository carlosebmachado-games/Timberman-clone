extends Node2D

signal to_lose

@onready var time_bar = $time_bar

var percent = 1.0

func _process(delta):
	if percent > 0:
		percent -= 0.1 * delta
		percent = clamp(percent, 0, 1)
		time_bar.region_rect = Rect2(0, 0, 508 * percent, 91)
		time_bar.position.x = -(1 - percent) * 508 / 2
	else:
		emit_signal("to_lose")

func add_time(delta):
	percent += delta
	percent = clamp(percent, 0, 1)
