extends Node2D

var expiriment_number = 1
onready var puzzles = [$ButtonPuzzle, $LightsOut]
var first_puzzle = 0
var second_puzzle = 1

var count = 0
var puzzles_done = 0

func _ready():
	Event.connect("ampoule_error", self, "restart_expirement")
	Event.connect("timer_expired", self, "restart_expirement")
	Event.connect("ampoule_injected", self, "_on_AmpouleInjected")
	Event.connect("lightsout_puzzle_completed", self, "on_Puzzle_Completed")
	Event.connect("switch_puzzle_completed", self, "on_Puzzle_Completed")
	start_puzzle([first_puzzle])

func restart_expirement():
	$AmpouleDisabled.visible = true
	$AmpouleDisabled.visible = false
	$ButtonPuzzle.visible = false
	$LightsOut.visible = false
	$ButtonPuzzle.init()
	$LightsOut.init()
	count = 0
	puzzles_done = 0
	if randi() % 2 == 1:
		first_puzzle = 0
		second_puzzle = 1
	else:
		first_puzzle = 1
		second_puzzle = 0
		
	yield(get_tree().create_timer(3.0), "timeout")
	Event.emit_signal("restart_experiment")
	expiriment_number += 1
	$ExpirimentLabel.text = str(expiriment_number)
	start_puzzle([first_puzzle])

func start_puzzle(puzzles: Array):
	yield(get_tree().create_timer(3.0), "timeout")
	for p in puzzles:
		activate_puzzle(p)

func _on_AmpouleInjected():
	$Timer.set_injectable(false)
	$ButtonPuzzle.visible = false
	$LightsOut.visible = false
	
	if count == 0:
		start_puzzle([second_puzzle])
	else:
		start_puzzle([0, 1])
	puzzles_done = 0
	count += 1

func activate_puzzle(i):
	print("activated puzzle:", i)
	puzzles[i].init()
	puzzles[i].visible = true

func on_Puzzle_Completed():
	puzzles_done += 1
	if count < 2 || puzzles_done == 2:
		$Timer.set_injectable(true)
