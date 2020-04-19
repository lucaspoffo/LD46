extends Node2D

var _seconds := 60

func _ready():
	_updateLabel()

func _on_Timer_timeout():
	_seconds -= 1
	_updateLabel()
	if _seconds == 0:
		_ampoleError()

func _ampoleError():
	Event.emit_signal("ampole_error")
	$Timer.stop()
	$TimerLabel.text = "--:--"

func _updateLabel():
	$TimerLabel.text = "00:%02d" % _seconds

func _on_Ampoule_pressed():
	if _seconds <= 10:
		_seconds = 60
		_updateLabel()
	else:
		_ampoleError()
