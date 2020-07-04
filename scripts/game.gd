extends Node2D

const TRUNK = 0
const LBRANCH = 1
const RBRANCH = 2

onready var man = $man
onready var camera = $camera
onready var trunks = $trunks
onready var dest_trunks = $dest_trunks
onready var time_bar = $canvas/time
onready var lbl_score = $canvas/score

var pre_trunk = preload("res://scenes/trunk.tscn")
var pre_lbranch = preload("res://scenes/branch_left.tscn")
var pre_rbranch = preload("res://scenes/branch_right.tscn")

var was_branch = false
var score = 0
const PLAYING = 1
const LOSE = 0
var status = PLAYING

func _ready():
	randomize()
	initial_trunks()
	time_bar.connect("to_lose", self, "lose")

func _input(event):
	event = camera.make_input_local(event)
	if event.is_pressed() and event is InputEventScreenTouch and status == PLAYING:
		if event.position.x < 360:
			man.to_left()
		else:
			man.to_right()
		
		if not branch_collision():
			man.to_cut()
			var first = get_first_trunk()
			trunks.remove_child(first)
			dest_trunks.add_child(first)
			first.cut(man.side)
			rand_trunk(Vector2(359.5, 933 - 10 * 176))
			drop()
			time_bar.add_time(0.018)
			score += 1
			lbl_score.text = String(score)
			if branch_collision():
				lose()
		else:
			lose()

func rand_trunk(pos):
	var t = rand_range(0, 3)
	if was_branch: t = TRUNK
	generate_trunk(int(t), pos)

func generate_trunk(type, pos):
	var new
	if type == LBRANCH:
		new = pre_lbranch.instance()
		new.add_to_group("left")
		was_branch = true
	elif type == RBRANCH:
		new = pre_rbranch.instance()
		new.add_to_group("right")
		was_branch = true
	else:
		new = pre_trunk.instance()
		was_branch = false
	new.position = pos
	trunks.add_child(new)

func initial_trunks():
	for i in range(0, 3):
		generate_trunk(TRUNK, Vector2(359.5, 933 - i * 176))
	for i in range(3, 10):
		rand_trunk(Vector2(359.5, 933 - i * 176))

func get_first_trunk():
	return trunks.get_children()[0]

func branch_collision():
	var side = man.side
	var first = get_first_trunk()
	if (side == man.LEFT and first.is_in_group("left") or
		side == man.RIGHT and first.is_in_group("right")):
		return true
	else:
		return false

func drop():
	for t in trunks.get_children():
		t.position.y += 176

func lose():
	man.die()
	time_bar.set_process(false)
	status = LOSE
	$restart.start()

func _on_restart_timeout():
	get_tree().reload_current_scene()
