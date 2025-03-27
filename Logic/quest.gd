class_name Quest extends Node

@export var faction : String # type of faction ("FJB","SEU","GOAT")
@export var description : String # quick description of quest
@export var type : int # type of faction quest (1,2,3,...)
@export var total : int # number requirement for quest completion
@export var progress : int # number progress for quest completion
@export var reward : int # amount of credits they'll get

@export var entityNode : Node2D # entity node for quest, if needed
@export var entityName : String # entity name for quest, if needed

var holder : CollisionObject2D
var progressSig : Signal #number progress for quest completion
var questTimer : Timer

# Called when the node enters the scene tree for the first time.
func _init(faction, description, type, total, baseCredits, entityNode = null, timeLimit = null) -> void:
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
				self.questTimer = Timer.new() # Create timer
				self.questTimer.wait_time = 10
				self.progressSig = self.questTimer.timeout
				
			_: # Default
				print("No type for quest of faction 'SEU'.")
			
	elif (faction == "FJB"):
		# Each of these is a different quest type
		match int(type):
			1: # Kill many enemies
				self.progressSig = SignalBus.enemy_killed
				
			2: # Bounty quest
				self.entityNode = entityNode
				self.progressSig = entityNode.bounty_claimed
				
			_: # Default
				print("No type for quest of faction 'FJB'.")
	elif (faction == "GOAT"):
		# Each of these is a different quest type
		match int(type):
			1: # Timed delivery quest
				self.reward -= timeLimit # Adjust reward based on time limit
				self.entityNode = entityNode
				self.entityName = self.entityNode.name
				self.questTimer = Timer.new() # Create timer
				self.questTimer.autostart = true
				self.questTimer.one_shot = true
				self.questTimer.wait_time = timeLimit as float
				self.progressSig = self.questTimer.timeout
				
			2: # Damageless delivery quest
				self.entityNode = entityNode
				self.entityName = self.entityNode.name
				self.progressSig = SignalBus.damage_taken
				
			_: # Default
				print("No type for quest of faction 'GOAT'.")
	else:
		print("No faction for quest.")
	
func activate():
	self.progressSig.connect(update_progress)
	
	# Quest-specific activations
	if self.faction == "SEU" and self.type == 2:
		self.startQuestTimer()
		SignalBus.start_charging_battery.connect(unpauseQuestTimer)
		SignalBus.stop_charging_battery.connect(pauseQuestTimer)
	elif self.faction == "FJB" and self.type == 2:
		self.startIndicator(entityNode)
	elif self.faction == "GOAT":
		self.startIndicator(entityNode)
		if self.type == 1:
			self.startQuestTimer()
	
func deactivate():
	self.progressSig.disconnect(update_progress)
	queue_free()

# Called everytime the signal is caught 
func update_progress(quester: CollisionObject2D = null):
	if holder == quester or self.questTimer != null: # Timeout signals do not emit with a quester, but should update progress anyways
		
		if progress < total:
			progress += 1
			SignalBus.quest_progressed.emit()
			
			# Restart energy station quest timer if we still need to charge the battery more. Otherwise it can stay timed out, as it is no longer useful.
			if faction == "SEU" and type == 2:
				self.questTimer.start(10)
				
		if progress == total:
			if faction == "GOAT": # GOAT quests fail on condition met
				SignalBus.quest_failed.emit()
			else: # FJB and SEU quests succeed on condition met
				SignalBus.quest_completed.emit()
	
	elif faction == "FJB" and type == 2 and holder != quester: # Fail bounty quest immediately if bounty target dies without being killed by the quest holder
		SignalBus.quest_failed.emit()
	
	# else do nothing

func startIndicator(entity: Node2D):
	SignalBus.show_indicator_arrow.emit(entity)

func startQuestTimer():
	add_child(self.questTimer)
	SignalBus.show_quest_timer.emit()

func pauseQuestTimer():
	self.questTimer.set_paused(true)
	
func unpauseQuestTimer():
	self.questTimer.set_paused(false)
	if self.questTimer.is_stopped():
		self.questTimer.start(10)

func isTimerStopped():
	if self.questTimer != null:
		if self.questTimer.is_stopped():
			return true

func getTimeLeft():
	if self.questTimer != null:
		return self.questTimer.time_left

func _to_string():
	return str("Faction: ", self.faction, "\nType: ", self.type, "\nProgress: ", self.progress, "\nTotal: ", self.total, "\nMisc: ", self.entityNode, ", ", self.entityName)
