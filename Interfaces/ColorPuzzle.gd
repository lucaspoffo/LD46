extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.modulate = mix_colors2(Color.cyan, Color.yellow)

func mix_colors(c1: Color, c2: Color) -> Color:
	var r = sqrt(pow(1 - c1.r, 2)  + pow(1 - c2.r, 2))
	var g = sqrt(pow(1 - c1.g, 2)  + pow(1 - c2.g, 2))
	var b = sqrt(pow(1 - c1.b, 2)  + pow(1 - c2.b, 2))
	return Color(r, g, b)

func mix_colors2(c1: Color, c2: Color) -> Color:
	var r = c1.r * c2.r
	var g = c1.g * c2.g
	var b = c1.b * c2.b
	return Color(r, g, b)
