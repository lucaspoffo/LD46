extends TextureButton

export var pitch_scale : float = 1.0

func _ready():
	$PressSound.pitch_scale = pitch_scale

func _on_OurButton_pressed():
	$PressSound.play()
