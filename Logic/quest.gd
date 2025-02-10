class_name Quest extends Node

@export var faction : String # type of faction ("FJB","SEU","GOAT")
@export var description : String # quick description of quest
@export var type : int # type of faction quest (1,2,3,...)
@export var total : int # number requirement for quest completion
@export var progress : int # number progress for quest completion
@export var reward : int # amount of credits they'll get
@export var entityID : String # entity ID for quest, if needed
var holder : CollisionObject2D
var progressSig : Signal #number progress for quest completion
var questTimer : Timer

# Called when the node enters the scene tree for the first time.
func _init(faction, description, type, total, baseCredits, entityID = null, timeLimit = null) -> void:
	self.faction = faction
	self.description = description
	self.type = type
	self.total = total
	self.reward = baseCredits * total
	self.progress = 0
	self.questTimer = null
	
	if (faction == "SEU"):
		# Each of these is a different quest type
		match int(type):
			1: # Mine rocks quest
				self.progressSig = SignalBus.rock_mined
			2: # Charge battery quest
				self.progressSig = SignalBus.rock_mined
			_: #default
				print("No type for quest of faction 'SEU'.")
		pass
	elif (faction == "FJB"):
		# Each of these is a different quest type
		match int(type):
			1: # Kill many enemies
				self.progressSig = SignalBus.enemy_killed
			_: #default
				print("No type for quest of faction 'FJB'.")
		pass
	elif (faction == "GOAT"):
		# Each of these is a different quest type
		match int(type):
			1: # Timed delivery quest
				self.reward -= timeLimit # Adjust reward based on time limit
				self.entityID = entityID
				self.questTimer = Timer.new() # Create timer
				self.questTimer.autostart = true
				self.questTimer.one_shot = true
				self.questTimer.wait_time = timeLimit as float
				self.progressSig = self.questTimer.timeout
				SignalBus.quest_received.connect(startQuestTimer)
				
			2: # Damageless delivery quest
				self.progressSig = SignalBus.damage_taken
				
			_: #default
				print("No type for quest of faction 'GOAT'.")
	else:
		print("No faction for quest.")
	
func activate():
	self.progressSig.connect(update_progress)
	
func deactivate():
	self.progressSig.disconnect(update_progress)
	queue_free()

# Called everytime the signal is caught 
func update_progress(quester: CollisionObject2D = null):
	#print("quest triggered, progress:",progress,"/",total)
	if holder == quester or quester == null:
		if progress < total:
			progress += 1
			SignalBus.quest_progressed.emit()
		if progress == total:
			if faction == "GOAT": # GOAT quests fail on condition met
				print("quest failed")
				SignalBus.quest_failed.emit()
			else: # FJB and SEU quests succeed on condition met
				SignalBus.quest_completed.emit()
	# else do nothing

func startQuestTimer(_quest):
	add_child(self.questTimer)
	#get_child(0).timeout.connect()
	#get_child(0).add_to_group("QuestTimer")
	print(get_child(0).get_time_left())
	#print(get_child(0).get_signal_connection_list("timeout"))

func getTimeLeft():
	if questTimer != null:
		return questTimer.time_left
