extends "draggable.gd"

@onready var questlist = $ItemList
var icon = preload("res://Sprites/icon.svg")
var file = FileAccess.open("res://quests.json",FileAccess.READ).get_as_text()
var last_mouse_pos = Vector2(0,0)
var json = JSON.new()
var rng = RandomNumberGenerator.new()

var filecontents = json.parse_string(file)

func _ready():
	# Set offset default value
	offset = Vector2(0,0)
		
func _process(delta):
	if dragging:
		questlist.position.y = (get_viewport().get_mouse_position() - offset).y
	#If the menu moves down too much it bounces back
	elif questlist.position.y > 0:
		questlist.position.y -= 15
	#experimenting with bouncing back down if move up too much
	#elif questlist.get_item_rect(9).position.y < (get_viewport_rect().size.y):
		#questlist.position.y += 15

func generateQuests() -> void:
	# Getting only the quests we have already (level 1 quests)
	var lvl1quests = filecontents["quests"]
	
	# Generate quests
	var goatQuests = []
	var fjbQuests = []
	var seuQuests = []
	for quest in lvl1quests:
		if quest.faction == "GOAT":
			goatQuests.append(quest)
		if quest.faction == "FJB":
			fjbQuests.append(quest)
		if quest.faction == "SEU":
			seuQuests.append(quest)
	var generatedQuests = []
	
	# Generate a quest for each quest faction:
	# TODO: Replace quest[0] with randomizing from the list
	var total = rng.randi_range(3, 7)
	var q1 = Quest.new(seuQuests[0].faction, seuQuests[0].desc.replace("x", str(total)), seuQuests[0].type, total)
	total = rng.randi_range(2, 5)
	var q2 = Quest.new(fjbQuests[0].faction, fjbQuests[0].desc.replace("x", str(total)), fjbQuests[0].type, total)
	total = rng.randi_range(3, 7)
	var q3 = Quest.new(goatQuests[0].faction, goatQuests[0].desc.replace("x", str(total)), goatQuests[0].type, total)
	generatedQuests.append(q1)
	generatedQuests.append(q2)
	generatedQuests.append(q3)
	print(generatedQuests)
	
	# Fill in quest list on UI
	questlist.clear()
	for i in generatedQuests:
		questlist.add_item(i.description,icon)

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
