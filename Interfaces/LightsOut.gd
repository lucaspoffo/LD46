extends Node2D

var lights
var neighbors = []
var deep = 0
func _ready():
	randomize()
	lights = get_children()
	for i in range(3):
		for j in range(3):
			var n = []
			var index = i * 3 + j
			if i > 0:
				n.append(lights[index - 3])
			if i < 2:
				n.append(lights[index + 3])
			if j > 0:
				n.append(lights[index - 1])
			if j < 2:
				n.append(lights[index + 1])
			neighbors.append(n)
			lights[index].connect("toggled", self, "_toogle_light", [index])
	for i in range(randi() % 6 + 3):
		var k = randi() % 9
		lights[k].set_pressed(!lights[k].is_pressed())

func _toogle_light(_toggle, i):
	deep += 1
	if deep == 1:
		for n in neighbors[i]:
			n.set_pressed(!n.is_pressed())
		_check_win()
	deep -= 1

func _check_win():
	var won = true
	for light in lights:
		if light.pressed:
			won = false
			
	if won:
		Event.emit_signal("lightsout_puzzle_completed")
		print("completed lights out puzzle")
