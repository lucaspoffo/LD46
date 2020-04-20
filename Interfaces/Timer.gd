extends Node2D

var _seconds := 60
var _ampoules
var can_inject := false
export var enabled_indicator: Texture
export var disabled_indicator: Texture
var already_error = false

func _ready():
	_ampoules = $Ampoules.get_children()
	set_ampoules_disabled(true)
	for a in _ampoules:
		a.connect("ampoule_pressed", self, "_on_Ampoule_pressed", [a])
	Event.connect("error_submit", self, "_on_Error_Submit")
	Event.connect("restart_experiment", self, "_on_Restart")
	set_injectable(false)
	_updateLabel()
	_check_timer_indicator()

func _on_Restart():
	_seconds = 60
	already_error = false
	$Timer.start()
	_updateLabel()
	set_injectable(false)
	_check_timer_indicator()
	#TODO: play animation
	set_ampoules_disabled(false)

func set_ampoules_disabled(disabled: bool):
	for a in _ampoules:
		a.disabled = disabled

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
	if !already_error:
		Event.emit_signal("ampoule_error")
		$Timer.stop()
		$TimerLabel.text = "--:--"
		already_error = true

func _updateLabel():
	$TimerLabel.text = "00:%02d" % _seconds

func _on_Ampoule_pressed(ampoule):
	ampoule.disabled = true
	if !can_inject:
		_ampouleError()
		return
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
