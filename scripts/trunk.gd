extends Node2D

func cut(side):
	if side == 1:
		$animation.play("to_right")
	else:
		$animation.play("to_left")
