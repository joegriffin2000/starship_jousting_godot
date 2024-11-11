extends "draggable.gd"

var e_button = preload("res://UI/upgrade_button.tscn")

func _ready() -> void:
	super()
	#var button = e_button.instantiate()
	var baseButton = get_node("BaseButton")
	for i in range(4):
		#var button = e_button.instantiate()
		var button = UpgradeButton.new()
		var line = Line2D.new()
		button.add_child(line)
		add_button(baseButton, button, i)
	
func add_button(parent_button, button_to_add, index: int):
	if parent_button.connect_count >= parent_button.max_connect_count:
		return
		
	if button_to_add.has_child("Line2D"):
		var line = button_to_add.get_node("Line2D")
		var start_line_offset = Vector2(0,0)
		var end_line_offset = Vector2(75,75)
		var button_offset = Vector2(0,0)
		var button_size = button_to_add.icon.get_size() + button_to_add.size
		var parent_size = parent_button.size
		var parent_position = parent_button.position
		
		if index%2 == 1:
			end_line_offset.x = - end_line_offset.x
			button_offset.x += button_size.x
		else:
			start_line_offset.x += button_size.x
			button_offset.x -= button_size.x
		if index >= 2:
			end_line_offset.y = - end_line_offset.y
			button_offset.y += button_size.y
		else:
			start_line_offset.y += button_size.y
			button_offset.y -= button_size.y
			
		var starting_point = start_line_offset
		var ending_point = starting_point + end_line_offset
		
		button_to_add.position = parent_position + button_offset - end_line_offset
		line.add_point(starting_point)
		line.add_point(ending_point)
		
		parent_button.connect_count += 1
		
		add_child(button_to_add)
