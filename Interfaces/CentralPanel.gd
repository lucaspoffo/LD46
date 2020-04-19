extends Node2D

var v1 = 0
var v2 = 0

func _ready():
	$Label.text = String(v1)
	$Label2.text = String(v2)

func _on_TextureButton_pressed():
	v1 += 1
	if v1 > 9:
		v1 = 0
	$Label.text = String(v1)
	
func _on_TextureButton2_pressed():
	v2 += 1
	if v2 > 9:
		v2 = 0
	$Label2.text = String(v2)

func _on_Submit_pressed():
	Event.emit_signal("central_panel_submit", v1 * 10 + v2)
