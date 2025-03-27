extends VBoxContainer

@onready var file = FileAccess.open("res://quests.json",FileAccess.READ).get_as_text()
@onready var filecontents = JSON.parse_string(file)
@onready var rng = RandomNumberGenerator.new()

@onready var SEUQuest = $SEUQuest
@onready var FJBQuest = $FJBQuest
@onready var GOATQuest = $GOATQuest
var generatedQuests = []
var selectedQuest = null


func generateQuests(carrier_name) -> void:
	
	var tree = get_tree()
	
	# Display player's current quest, if they have one
	if ShipData.quest != null:
		$CurrentQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestText.text = ShipData.quest.description
		$CurrentQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestReward.text = str("Reward: ", ShipData.quest.reward, " credits")
	else:
		$CurrentQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestText.text = "No active quest"
		$CurrentQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestReward.visible = false
	
	# Fetch quest blanks from quest list
	var lvl1quests = filecontents["quests"]
	
	# Set up to generate quests
	var seuQuests = []
	var fjbQuests = []
	var goatQuests = []
	for quest in lvl1quests:
		if quest.faction == "SEU":
			seuQuests.append(quest)
		if quest.faction == "FJB":
			fjbQuests.append(quest)
		if quest.faction == "GOAT":
			goatQuests.append(quest)
	
	# Generate a quest for each quest faction
	# Quest.new(faction, description, type, total, baseCredits)
	
	# SEU Quests
	var qNum = rng.randi_range(0, 1)
	var total = rng.randi_range(3, 7)
	var seu = Quest.new(seuQuests[qNum].faction, seuQuests[qNum].desc.replace("x", str(total)), seuQuests[qNum].type, total, seuQuests[qNum].credits)
	
	# FJB Quests
	qNum = rng.randi_range(0, 1)
	total = rng.randi_range(2, 5)
	var entity_list = tree.get_nodes_in_group("Enemies")
	if entity_list.size() < 1: # Do not ever assign bounty quest if there is nobody to give a bounty for
		qNum = 0
	var selected_entity
	var fjb
	if qNum == 1: # Bounty quest
		var chosen_enemy = entity_list[randi() % entity_list.size()]
		fjb = Quest.new(fjbQuests[qNum].faction, fjbQuests[qNum].desc.replace("x", str(chosen_enemy.playerName)), fjbQuests[qNum].type, 1, fjbQuests[qNum].credits, chosen_enemy)
	else: # Other quests
		fjb = Quest.new(fjbQuests[qNum].faction, fjbQuests[qNum].desc.replace("x", str(total)), fjbQuests[qNum].type, total, fjbQuests[qNum].credits)
	
	# GOAT Quests
	qNum = rng.randi_range(0, 1)
	var entityID = rng.randi_range(0, 3) # Carrier ship ID
	entity_list = tree.root.get_node("Game").get_node("CarrierShips").get_children()
	entity_list.erase(tree.root.get_node("Game").get_node("CarrierShips").get_node(str(carrier_name)))  # Remove the carrier name we accessed from the list
	selected_entity = entity_list[entityID]
	
	var timeLimit = rng.randi_range(30, 120) # Time in seconds
	var base = goatQuests[qNum].desc
	var updStr = base.replace("x", selected_entity.name)
	var updDesc = updStr.replace("y time", str(timeLimit, " seconds"))
	
	var goat = Quest.new(goatQuests[qNum].faction, updDesc, goatQuests[qNum].type, 1, goatQuests[qNum].credits, selected_entity, timeLimit)
	
	generatedQuests = []
	generatedQuests.append(seu)
	generatedQuests.append(fjb)
	generatedQuests.append(goat)
	
	# Fill each new quest
	$SEUQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestText.text = seu.description
	$SEUQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestReward.text = str("Reward: ", seu.reward, " credits")
	$FJBQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestText.text = fjb.description
	$FJBQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestReward.text = str("Reward: ", fjb.reward, " credits")
	$GOATQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestText.text = goat.description
	$GOATQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestReward.text = str("Reward: ", goat.reward, " credits")
	

func _on_seu_quest_toggled(toggled_on: bool) -> void:
	if toggled_on:
		selectedQuest = generatedQuests[0]
	else:
		selectedQuest = null
func _on_fjb_quest_toggled(toggled_on: bool) -> void:
	if toggled_on:
		selectedQuest = generatedQuests[1]
	else:
		selectedQuest = null
func _on_goat_quest_toggled(toggled_on: bool) -> void:
	if toggled_on:
		selectedQuest = generatedQuests[2]
	else:
		selectedQuest = null


func _on_take_quest_pressed() -> void:
	if selectedQuest != null:
		
		# Deactivate our past quest, if we already had one that we're overwriting
		if ShipData.quest != null:
			ShipData.quest.deactivate()
			SignalBus.quest_removed.emit()
		
		# Receive selected quest
		SignalBus.quest_received.emit(selectedQuest)
		
		# Update display to show current active quest
		$CurrentQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestText.text = selectedQuest.description
		$CurrentQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestReward.text = str("Reward: ", selectedQuest.reward, " credits")
		$CurrentQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestReward.visible = true
		
		# Deselect quests in the menu
		SEUQuest.set_pressed(false)
		FJBQuest.set_pressed(false)
		GOATQuest.set_pressed(false)
		
func removeQuests():
	for q in generatedQuests:
		if q != ShipData.quest:
			q.deactivate()
