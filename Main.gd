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
var stage_animation := {
	0: "baby",
	1: "pickleman",
	2: "default",
	3: "bombado"
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
	$Light2D/AnimationPlayer.play("Light_Blink")
	start_puzzle([first_puzzle])
	yield(get_tree().create_timer(3.0), "timeout")
	$Timer.set_ampoules_disabled(false)

func restart_expirement():
	Event.emit_signal("experiment_failed")
	
	$Fib/FibSubmit.disabled = true
	$Fib/FibSubmit2.disabled = true
	$ButtonPuzzle.visible = false
	$LightsOut.visible = false
	
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
	
	$Capsula/Gosma/Alien.play(stage_animation[0])
	
	$AnimationPlayer.play("Movement_in")
	$Light2D.color = Color.white
	$Capsula/Gosma.modulate = Color.white
	yield($AnimationPlayer, "animation_finished")
	$Light2D/AnimationPlayer.play("Light_Blink")

	Event.emit_signal("restart_experiment")
	$Fib/FibSubmit.disabled = false
	$Fib/FibSubmit2.disabled = false
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
	# evolve once when resolving both puzzles first time
	if count == 2 && puzzles_done == 2:
		evolve()
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
		$Fib/FibSubmit.disabled = true
		$Fib/FibSubmit2.disabled = true
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
	# Fix bubble when evolving to fast
	if $Capsula/Gosma/BubblesEvolvolution/AnimationPlayer.is_playing():
		yield($Capsula/Gosma/BubblesEvolvolution/AnimationPlayer, "animation_finished")
	$Capsula/Gosma/BubblesEvolvolution/AnimationPlayer.play("Transform")
	#TODO play transformation animation
	if stage == 5:
		# Disable all inputs and stop timer
		$Timer/Timer.stop()
		get_viewport().gui_disable_input = true

func change_experiment_animation():
	if stage_animation.get(stage):
		$Capsula/Gosma/Alien.play(stage_animation[stage])
	else:
		$Capsula/Gosma/Alien.play(stage_animation[3])
		$End/EndGameAnimation/AnimationPlayer.play("End")
		$"/root/Music".stop()
