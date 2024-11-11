extends "draggable.gd"

@onready var questlist = $ItemList
var icon = preload("res://Sprites/icon.svg")
var last_mouse_pos = Vector2(0,0)

func _ready():
	#set offset default value
	offset = Vector2(0,0)
	var file = FileAccess.open("res://file.txt",FileAccess.READ).get_as_text()
	var contents = file.split("\n")
	contents.remove_at(len(contents)-1)
	#Fill in quests
	for i in contents:
		questlist.add_item(i,icon)
		
func _process(delta):
	if dragging:
		questlist.position.y = (get_viewport().get_mouse_position() - offset).y
	#If the menu moves down too much it bounces back
	elif questlist.position.y > 0:
		questlist.position.y -= 15
	#experimenting with bouncing back down if move up too much
	#elif questlist.get_item_rect(9).position.y < (get_viewport_rect().size.y):
		#questlist.position.y += 15

func _gui_input(event: InputEvent) -> void:
	if event.is_action("scroll_up"):
		questlist.position.y -= 10
	if event.is_action("scroll_down"):
		questlist.position.y += 10

func _on_item_list_gui_input(event: InputEvent) -> void:
	if !dragging and event.is_action_pressed("left_click"):
		var mouse_pos = get_viewport().get_mouse_position()
		offset = mouse_pos - questlist.position
		dragging = true
		#get_tree().set_input_as_handled()
		
	if dragging and event.is_action_released("left_click"):
		dragging = false
		

func _on_item_list_item_selected(index: int) -> void:
	SignalBus.quest_received.emit(questlist.get_item_text(index))
