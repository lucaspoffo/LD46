extends TextureButton

export var pitch_scale : float = 1.0
export var audio : AudioStream

func _ready():
	$PressSound.pitch_scale = pitch_scale
	$PressSound.stream = audio

func _on_OurButton_pressed():
	$PressSound.play()
