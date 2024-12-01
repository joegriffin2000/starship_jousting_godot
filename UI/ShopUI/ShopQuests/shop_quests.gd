extends VBoxContainer

@onready var file = FileAccess.open("res://quests.json",FileAccess.READ).get_as_text()
@onready var json = JSON.new()
@onready var filecontents = json.parse_string(file)
@onready var rng = RandomNumberGenerator.new()

@onready var SEUQuest = $SEUQuest
@onready var FJBQuest = $FJBQuest
@onready var GOATQuest = $GOATQuest
var generatedQuests = []
var selectedQuest = null

func _ready():
	pass

func generateQuests() -> void:
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
	
	# Generate a quest for each quest faction
	# TODO: Replace quest[0] with randomizing from the list
	var total = rng.randi_range(3, 7)
	var seu = Quest.new(seuQuests[0].faction, seuQuests[0].desc.replace("x", str(total)), seuQuests[0].type, total, seuQuests[0].credits)
	
	total = rng.randi_range(2, 5)
	var fjb = Quest.new(fjbQuests[0].faction, fjbQuests[0].desc.replace("x", str(total)), fjbQuests[0].type, total, fjbQuests[0].credits)
	
	total = rng.randi_range(3, 7)
	var time = rng.randi_range(30, 120)
	var base = goatQuests[0].desc
	var updTotal = base.replace("x", str(total))
	var updTime = updTotal.replace("y time", str(time, " seconds"))
	var goat = Quest.new(goatQuests[0].faction, updTime, goatQuests[0].type, total, goatQuests[0].credits)
	
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
		
