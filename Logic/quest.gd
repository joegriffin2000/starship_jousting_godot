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
				self.questTimer = Timer.new() # Create timer
				self.questTimer.wait_time = 10
				self.progressSig = self.questTimer.timeout
				SignalBus.quest_received.connect(startQuestTimer)
				SignalBus.start_charging_battery.connect(unpauseQuestTimer)
				SignalBus.stop_charging_battery.connect(pauseQuestTimer)
			_: # Default
				print("No type for quest of faction 'SEU'.")
		pass
	elif (faction == "FJB"):
		# Each of these is a different quest type
		match int(type):
			1: # Kill many enemies
				self.progressSig = SignalBus.enemy_killed
			2: # Bounty
				self.total = 1
			_: # Default
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
				
			_: # Default
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
			print("quest progressed")
			
			# Restart energy station quest timer if we still need to charge the battery more. Otherwise it can stay timed out, as it is no longer useful.
			if faction == "SEU" and type == 2:
				self.questTimer.start(10)
				
		if progress == total:
			if faction == "GOAT": # GOAT quests fail on condition met
				print("quest failed")
				SignalBus.quest_failed.emit()
			else: # FJB and SEU quests succeed on condition met
				SignalBus.quest_completed.emit()
	
	# else do nothing

func startQuestTimer(_quest):
	add_child(self.questTimer)
	SignalBus.show_quest_timer.emit()

func pauseQuestTimer():
	print("Pausing timer")
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
