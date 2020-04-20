extends Node2D

var v1 = 0
var v2 = 0

func _ready():
	$Label.text = String(v1)
	$Label2.text = String(v2)

func set_triangle_disabled(disabled : bool):
	$Submit.disabled = disabled
	$Submit2.disabled = disabled

func set_binary_disabled(disabled : bool):
	$Binary0.disabled = disabled
	$Binary1.disabled = disabled

func _on_Submit_pressed():
	Event.emit_signal("triangle_submit", v1 * 10 + v2)

func _on_Binary_pressed():
	Event.emit_signal("binary_submit", v1 * 10 + v2)

func _on_Add_pressed():
	v1 += 1
	if v1 > 9:
		v1 = 0
	$Label.text = String(v1)

func _on_Add2_pressed():
	v2 += 1
	if v2 > 9:
		v2 = 0
	$Label2.text = String(v2)
