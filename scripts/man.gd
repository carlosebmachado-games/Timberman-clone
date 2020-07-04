extends Node2D

onready var anim = $animation
onready var idle = $man_idle
onready var cut = $man_cut
onready var rip = $rip

const RIGHT = 0
const LEFT = 1
var side

func to_left():
	position = Vector2(-31.5, 781)
	idle.flip_h = false
	cut.flip_h = false
	rip.position = Vector2(46, 98)
	rip.flip_h = false
	side = LEFT

func to_right():
	position = Vector2(369.5, 781)
	idle.flip_h = true
	cut.flip_h = true
	rip.position = Vector2(126, 98)
	rip.flip_h = true
	side = RIGHT

func to_cut():
	anim.play("cut")

func die():
	anim.stop()
	cut.hide()
	idle.hide()
	rip.show()
