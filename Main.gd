extends Node2D

var expiriment_number = 1
onready var puzzles = [$ButtonPuzzle, $LightsOut]
var first_puzzle = 0
var second_puzzle = 1

var count = 0
var puzzles_done = 0

var fib_sequence = [0, 1, 1, 2, 3, 5, 8]
var current_fib = 0

var stage = 0
var stageAnimation := {
	1: "stage_1",
	2: "stage_2",
	3: "stage_3",
}

func _ready():
	Event.connect("ampoule_error", self, "restart_expirement")
	Event.connect("timer_expired", self, "restart_expirement")
	Event.connect("ampoule_injected", self, "_on_AmpouleInjected")
	Event.connect("lightsout_puzzle_completed", self, "on_Puzzle_Completed")
	Event.connect("switch_puzzle_completed", self, "on_Puzzle_Completed")
	
	Event.connect("binary_submit", self, "_on_BinarySubmit")
	Event.connect("triangle_submit", self, "_on_TriangleSubmit")
	yield(get_tree().create_timer(2.0), "timeout")
	$AnimationPlayer.play("Movement_in")
	yield($AnimationPlayer, "animation_finished")
	#$Light2D/AnimationPlayer.play("Light_Blink")
	start_puzzle([first_puzzle])

func restart_expirement():
	$ButtonPuzzle.visible = false
	$LightsOut.visible = false
	
	$FibSubmit.disabled = false
	$FibSubmit2.disabled = false
	
	$CentralPanel.set_binary_disabled(false)
	$CentralPanel.set_triangle_disabled(false)
	
	$ButtonPuzzle.init()
	$LightsOut.init()
	count = 0
	puzzles_done = 0
	current_fib = 0
	stage = 0
	if randi() % 2 == 1:
		first_puzzle = 0
		second_puzzle = 1
	else:
		first_puzzle = 1
		second_puzzle = 0
	$Light2D/AnimationPlayer.stop()
	$AnimationPlayer.play("Color_change")
	yield($AnimationPlayer, "animation_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	
	$AnimationPlayer.play("Movement")
	yield($AnimationPlayer, "animation_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	
	

	$AnimationPlayer.play("Movement_in")
	$Light2D.color = Color.white
	$Capsula/Gosma.modulate = Color.white
	yield($AnimationPlayer, "animation_finished")
	$Light2D/AnimationPlayer.play("Light_Blink")

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
		
func _on_FibSubmit_pressed():
	var value = $CentralPanel.v1 * 10 + $CentralPanel.v2
	if value == fib_sequence[current_fib]:
		current_fib += 1
	else:
		current_fib = 0
		Event.emit_signal("error_submit")
	if current_fib == fib_sequence.size():
		$FibSubmit.disabled = true
		$FibSubmit2.disabled = true
		evolve()
		print("Fibonacci sequence submited")

func _on_TriangleSubmit(value):
	if value == 13:
		$CentralPanel.set_triangle_disabled(true)
		evolve()
	else:
		Event.emit_signal("error_submit")
	
func _on_BinarySubmit(value):
	if value == 27:
		$CentralPanel.set_binary_disabled(true)
		evolve()
	else:
		Event.emit_signal("error_submit")
		
func evolve():
	stage += 1
	print("evolving to stage: ", stage)
	#TODO play transformation animation
	if stage == 3:
		# Disable all inputs
		get_viewport().gui_disable_input = true
		#TODO: Play end animation
