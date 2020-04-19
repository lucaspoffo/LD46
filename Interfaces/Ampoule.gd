extends TextureButton
signal ampoule_pressed

func _on_Ampoule_pressed():
	emit_signal("ampoule_pressed")
