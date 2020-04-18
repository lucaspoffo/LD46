extends Node2D


onready var _switchs = $Switchs.get_children() 
var _switch_state = {} 

func _ready():
	for i in range(_switchs.size()):
		_switchs[i].modulate = Color.red
		_switch_state[i] = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	print("teste")
