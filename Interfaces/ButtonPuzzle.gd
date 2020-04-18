extends Node2D

var _switch_values: Dictionary = {}
var _values := [0, 0]
var _min_values := [0, 0]
var _max_values := [0, 0]
var _measure_len = 50
var _desired_values = [0, 0]

onready var _measure_pos := [$Mesure1.position, $Mesure2.position]
onready var _switchs: Array = $Switchs.get_children()

func _ready():
	randomize()
	for i in range(_switchs.size()):
		_switchs[i].connect("toggled", self, "_update_state")
		var switch_value = [0, 0]
		for i in range(2):
			var value = (randi() % 3 + 1)
			if randi() % 2 == 0:
				value *= -1
			switch_value[i] = value
		
		_switch_values[i] = switch_value
		if _switch_values[i][0] < 0:
			_min_values[0] += _switch_values[i][0]
		if _switch_values[i][1] < 0:
			_min_values[1] += _switch_values[i][1]
		if _switch_values[i][0] > 0:
			_max_values[0] += _switch_values[i][0]
		if _switch_values[i][1] > 0:
			_max_values[1] += _switch_values[i][1]
		if randi() % 2 == 0:
			_desired_values[0] += switch_value[0]
			_desired_values[1] += switch_value[1]
			
	# Treat case when no button was selected in solution
	if _desired_values[0] == 0 && _desired_values[1] == 0:
		var i = randi() % _switchs.size()
		_desired_values[0] += _switch_values[i][0]
		_desired_values[1] += _switch_values[i][1]

func _update_state(_toggled):
	_values = [0, 0]
	for i in range(_switchs.size()):
		if _switchs[i].pressed:
			_values[0] += _switch_values[i][0]
			_values[1] += _switch_values[i][1]
	update()
	if _values[0] == _desired_values[0] && _values[1] == _desired_values[1]:
		Event.emit_signal("switch_puzzle_completed")
		print("completed switch puzzle")
	
func _draw():
	draw_measure(0)
	draw_measure(1)
	
func draw_measure(i):
	var start_arc = -PI * .9
	var end_arc =  -PI * .1
	var arc_angle = PI * .8
	var phi = float(_values[i] - _min_values[i]) / (_max_values[i] - _min_values[i])
	var to = Vector2(_measure_len, 0).rotated(start_arc + arc_angle * phi)
	
	draw_line(_measure_pos[i], _measure_pos[i] + to, Color.red, 3)
	draw_arc(_measure_pos[i], _measure_len, start_arc, end_arc, 24, Color.white, 3)
	
	var desired_phi = float(_desired_values[i] - _min_values[i]) / (_max_values[i] - _min_values[i])
	
	var desired_start_arc = start_arc + arc_angle * desired_phi - PI/24
	var desired_end_arc = start_arc + arc_angle * desired_phi + PI/24
	draw_arc(_measure_pos[i], _measure_len, desired_start_arc, desired_end_arc, 24, Color.red, 3)
