extends Node2D

var _seconds := 60
var _ampoules
var can_inject := false
export var enabled_indicator: Texture
export var disabled_indicator: Texture

func _ready():
	_ampoules = $Ampoules.get_children()
	for a in _ampoules:
		a.connect("ampoule_pressed", self, "_on_Ampoule_pressed", [a])
	Event.connect("error_submit", self, "_on_Error_Submit")
	Event.connect("restart_experiment", self, "_on_Restart")
	set_injectable(false)
	_updateLabel()
	_check_timer_indicator()

func _on_Restart():
	_seconds = 60
	$Timer.start()
	_updateLabel()
	set_injectable(false)
	_check_timer_indicator()
	#TODO: play animation
	for a in _ampoules:
		a.disabled = false

func _on_Error_Submit():
	_seconds -= 5
	_updateLabel()
	_checkTimerExpired()
	# Reset Timer
	$Timer.start()

func _on_Timer_timeout():
	_seconds -= 1
	_updateLabel()
	_checkTimerExpired()
	_check_timer_indicator()

func _checkTimerExpired():
	if _seconds <= 0:
		Event.emit_signal("timer_expired")
		$Timer.stop()
		$TimerLabel.text = "--:--"

func _ampouleError():
	Event.emit_signal("ampoule_error")
	$Timer.stop()
	$TimerLabel.text = "--:--"

func _updateLabel():
	$TimerLabel.text = "00:%02d" % _seconds

func _on_Ampoule_pressed(ampoule):
	if !can_inject:
		#TODO: play error sound
		return
	ampoule.disabled = true
	if _seconds <= 10:
		_seconds = 60
		_updateLabel()
		Event.emit_signal("ampoule_injected")
	else:
		_ampouleError()

func set_injectable(injectable: bool):
	can_inject = injectable
	if injectable:
		$CanInjectIndicator.texture = enabled_indicator
	else:
		$CanInjectIndicator.texture = disabled_indicator

func _check_timer_indicator():
	if _seconds <= 10:
		$TimerIndicator.texture = enabled_indicator
	else:
		$TimerIndicator.texture = disabled_indicator
