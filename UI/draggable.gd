class_name Draggable
extends Control

var dragging = false
var offset: Vector2

func _ready():
	gui_input.connect(on_gui_input)
	
func _process(delta: float):
	if dragging:
		position = get_viewport().get_mouse_position() - offset
	
func on_gui_input(event: InputEvent):
	if !dragging and event.is_action_pressed("left_click"):
		var mouse_pos = get_viewport().get_mouse_position()
		offset = mouse_pos - position
		dragging = true
		#get_tree().set_input_as_handled()
		
	if dragging and event.is_action_released("left_click"):
		dragging = false
