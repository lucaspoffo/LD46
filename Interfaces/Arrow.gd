extends Sprite

class_name Arrow

var neighbors: Dictionary
var orientation := Vector2(0, 1)
var visited := false

func _ready():
	rotate_arrow()

func rotate_arrow():
	orientation = orientation.rotated(-PI / 2)
	rotate(PI / 2)
	
func rotate_to_orientation(x: Vector2):
	orientation = x
	rotation = x.angle_to(Vector2.DOWN)
	
func update_color(c: Color):
	modulate = c

func _on_TextureButton_pressed():
	rotate_arrow()
