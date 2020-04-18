extends Label

var _seconds := 60

func _ready():
	pass # Replace with function body.

func _on_Timer_timeout():
	_seconds -= 1
	text = String(_seconds)
	if _seconds == 0:
		$Timer.stop()
		Event.emit_signal("timer_expired")
