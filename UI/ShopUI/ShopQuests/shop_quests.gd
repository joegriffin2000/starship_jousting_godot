extends VBoxContainer

@onready var file = FileAccess.open("res://quests.json",FileAccess.READ).get_as_text()
@onready var filecontents = JSON.parse_string(file)
@onready var rng = RandomNumberGenerator.new()

@onready var SEUQuest = $SEUQuest
@onready var FJBQuest = $FJBQuest
@onready var GOATQuest = $GOATQuest
@onready var tree = get_tree()
var generatedQuests = []
var seuQuests = []
var fjbQuests = []
var goatQuests = []
var selectedQuest = null

func _ready() -> void:
	# Fetch quest blanks from quest list
	var lvl1quests = filecontents["quests"]
	
	# Set up to generate quests
	for quest in lvl1quests:
		if quest.faction == "SEU":
			seuQuests.append(quest)
		elif quest.faction == "FJB":
			fjbQuests.append(quest)
		elif quest.faction == "GOAT":
			goatQuests.append(quest)

func generateQuests(carrier_name) -> void:
	
	# Display player's current quest, if they have one
	if ShipData.quest != null:
		$CurrentQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestText.text = ShipData.quest.description
		$CurrentQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestReward.text = str("Reward: ", ShipData.quest.reward, " credits")
	else:
		$CurrentQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestText.text = "No active quest"
		$CurrentQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestReward.visible = false
	
	# Generate a quest for each quest faction
	# Quest.new(faction, description, type, total, baseCredits)
	var seu = generate_seu_quest(seuQuests)
	var fjb = generate_fjb_quest(fjbQuests)
	var goat = generate_goat_quest(goatQuests, carrier_name)
	
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


func generate_seu_quest(seuQuests) -> Quest:
	var qNum = rng.randi_range(0, 1)
	var total = rng.randi_range(3, 7)
	return Quest.new(seuQuests[qNum].faction, seuQuests[qNum].desc.replace("x", str(total)), seuQuests[qNum].type, total, seuQuests[qNum].credits)

func generate_fjb_quest(fjbQuests) -> Quest:
	var qNum = rng.randi_range(0, 1)
	var total = rng.randi_range(2, 5)
	var entity_list = tree.get_nodes_in_group("Enemies")
	if entity_list.size() < 1: # Do not ever assign bounty quest if there is nobody to give a bounty for
		qNum = 0
	if qNum == 1: # Bounty quest
		var chosen_enemy = entity_list[randi() % entity_list.size()]
		return Quest.new(fjbQuests[qNum].faction, fjbQuests[qNum].desc.replace("x", str(chosen_enemy.playerName)), fjbQuests[qNum].type, 1, fjbQuests[qNum].credits, chosen_enemy)
	else: # Other quests
		return Quest.new(fjbQuests[qNum].faction, fjbQuests[qNum].desc.replace("x", str(total)), fjbQuests[qNum].type, total, fjbQuests[qNum].credits)

func generate_goat_quest(goatQuests, carrier_name) -> Quest:
	var qNum = rng.randi_range(0, 1)
	var entityID = rng.randi_range(0, 3) # Carrier ship ID
	var entity_list = tree.root.get_node("Game").get_node("CarrierShips").get_children()
	entity_list.erase(tree.root.get_node("Game").get_node("CarrierShips").get_node(str(carrier_name)))  # Remove the carrier name we accessed from the list
	var selected_entity = entity_list[entityID]
	
	var timeLimit = rng.randi_range(30, 90) # Time in seconds
	var base = goatQuests[qNum].desc
	var updStr = base.replace("x", selected_entity.name)
	var updDesc = updStr.replace("y time", str(timeLimit, " seconds"))
	
	return Quest.new(goatQuests[qNum].faction, updDesc, goatQuests[qNum].type, 1, goatQuests[qNum].credits, selected_entity, timeLimit)


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
		
		# Deactivate our past quest, if we already had one that we're overwriting and it's not one of the 3 still on display
		if ShipData.quest != null and ShipData.quest not in generatedQuests:
			ShipData.quest.deactivate()
			SignalBus.quest_removed.emit()
		
		var selected_quest_invalid = false
		# Check to make sure FJB Bounty quest is still valid (target isn't dead or disconnected), if not deselect and regenerate
		if selectedQuest.faction == "FJB" and selectedQuest.type == 2:
			if (not is_instance_valid(selectedQuest.entityNode)) or selectedQuest.entityNode.is_queued_for_deletion() or selectedQuest.entityNode.health == 0:
				selected_quest_invalid = true
		
		if selected_quest_invalid:
			if selectedQuest.faction == "FJB" and selectedQuest.type == 2:
				var newFJB = generate_fjb_quest(fjbQuests)
				generatedQuests[2] = newFJB
				$FJBQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestText.text = newFJB.description
				$FJBQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestReward.text = str("Reward: ", newFJB.reward, " credits")
				
		else:
			# Receive selected quest
			SignalBus.quest_received.emit(selectedQuest)
			#print(str(selectedQuest))
			
			# Update display to show current active quest
			$CurrentQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestText.text = selectedQuest.description
			$CurrentQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestReward.text = str("Reward: ", selectedQuest.reward, " credits")
			$CurrentQuest/MarginContainer/HBoxContainer/VBoxContainer/QuestReward.visible = true
			
		resetQuestMenu()

func resetQuestMenu():
	# Deselect quests in the menu
	SEUQuest.set_pressed(false)
	FJBQuest.set_pressed(false)
	GOATQuest.set_pressed(false)
	
func removeQuests():
	for q in generatedQuests:
		if q != ShipData.quest:
			q.deactivate()
