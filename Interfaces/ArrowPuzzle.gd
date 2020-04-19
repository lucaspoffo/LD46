extends Node2D

var arrows: Array
var neighbors := []
var start_pos := 0
var win_pos := 8

var problems = [
[Vector2(1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(1, 0), Vector2(1, 0), Vector2(0, -1)],
[Vector2(1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, -1), Vector2(-1, 0), Vector2(-1, 0), Vector2(1, 0), Vector2(1, 0), Vector2(0, -1)],
[Vector2(1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0), Vector2(1, 0), Vector2(1, 0), Vector2(0, -1)],
[Vector2(1, 0), Vector2(0, -1), Vector2(0, -1), Vector2(1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1), Vector2(1, 0), Vector2(0, -1)],
[Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, -1), Vector2(1, 0), Vector2(1, 0), Vector2(0, -1)],
[Vector2(0, -1), Vector2(0, -1), Vector2(-1, 0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, -1), Vector2(1, 0), Vector2(1, 0), Vector2(0, -1)],
[Vector2(0, -1), Vector2(0, -1), Vector2(-1, 0), Vector2(0, -1), Vector2(1, 0), Vector2(0, -1), Vector2(1, 0), Vector2(0, 1), Vector2(0, -1)],
[Vector2(0, -1), Vector2(1, 0), Vector2(0, -1), Vector2(0, -1), Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(0, 1), Vector2(0, -1)],
[Vector2(0, -1), Vector2(1, 0), Vector2(0, -1), Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0), Vector2(1, 0), Vector2(1, 0), Vector2(0, -1)]
]

func _ready():
	randomize()
	arrows = $Arrows.get_children()
	
	$Red.modulate = Color.red
	$Blue.modulate = Color.blue
	$Green.modulate = Color.green
	
	# Update arrows neighbors
	for i in range(3):
		for j in range(3):
			var n := {}
			var index = i * 3 + j
			if i > 0:
				n[str(Vector2.DOWN)] = arrows[index - 3]
			if i < 2:
				n[str(Vector2.UP)] = arrows[index + 3]
			if j > 0:
				n[str(Vector2.LEFT)] = arrows[index - 1]
			if j < 2:
				n[str(Vector2.RIGHT)] = arrows[index + 1]
			arrows[index].neighbors = n
	
	# Choose problem	
	var problem = problems[randi() % problems.size()]	
	for i in range(9):
		arrows[i].rotate_to_orientation(problem[i])
	
	# Generate Arrows Colors
	var indexes := [0, 1, 2, 3, 4, 5 ,6 ,7, 8]
	indexes.shuffle()
	var colors = [Color.red, Color.blue, Color.green]
	var color_groups = ["arrow_red", "arrow_blue", "arrow_green"]
	for i in range(3):
		var color = colors[i]
		var group = color_groups[i]
		for j in range(3):
			var k = indexes.pop_back()
			var arrow = arrows[k]
			arrow.add_to_group(group)
			arrow.update_color(color)
	
	# Randomize grid
	for i in range(3):
		var group = color_groups[i]
		var random_rotations = randi() % 4
		for _k in range(random_rotations):
			rotate_arrows(group)
	# Check if is already won and just rotate won random
	# Not perfect but helps
	if check_win():
		rotate_arrows(color_groups[randi() % 3])
			
func check_all_problems_wins():
	for j in range(problems.size()):	
		var problem = problems[j]
		for i in range(9):
			arrows[i].rotate_to_orientation(problem[i])
		if check_win():
			print("won")
		else:
			print("lost: ", j)

func make_solution():
	var stack := [arrows[0]]
	while stack.size() > 0:
		var current = stack.pop_back()
		
func check_win() -> bool:
	var current = arrows[0]
	for a in arrows:
		a.visited = false
		
	while current:
		current.visited = true
		if current == arrows[8] && arrows[8].orientation.y == -1:
			return true
		# We round here because -0 is a thing =/
		var x = round(current.orientation.x)
		var y = round(current.orientation.y)
		current = current.neighbors.get("(%d, %d)" % [x, y])
		if current && current.visited:
			return false
	return false

func rotate_arrows(group):
	for a in get_tree().get_nodes_in_group(group):
		a.rotate_arrow()

func check_and_emit_win():
	if check_win():
		print("arrow puzzle completed")
		Event.emit_signal("arrow_puzzle_completed")

func _on_Red_pressed():
	rotate_arrows("arrow_red")
	check_and_emit_win()

func _on_Green_pressed():
	rotate_arrows("arrow_green")
	check_and_emit_win()

func _on_Blue_pressed():
	rotate_arrows("arrow_blue")
	check_and_emit_win()

func _on_GenerateLevel_pressed():
	var text = []
	for a in arrows:
		var x = round(a.orientation.x)
		var y = round(a.orientation.y)
		text.push_back("Vector2(%d, %d)" % [x,y])
	print(text)
