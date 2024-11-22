class_name Quest

@export var faction : String #type of faction ("FJB","SEU","GOAT")
@export var description : String #quick description of quest
@export var type : int #type of faction quest (1,2,3,...)
@export var total : int #number requirement for quest completion
@export var progress : int #number progress for quest completion
@export var reward : int #amount of credits they'll get
var holder : Variant
var progressSig : Signal #number progress for quest completion

# Called when the node enters the scene tree for the first time.
func _init(faction, description, type, total, baseCredits) -> void:
	self.faction = faction
	self.description = description
	self.type = type
	self.total = total
	self.reward = baseCredits * total
	self.progress = 0
	
	if (faction == "GOAT"):
		#each of these is a different quest type
		match int(type):
			1: 
				self.progressSig = SignalBus.rock_mined
			2: 
				self.progressSig = SignalBus.rock_mined
			_: #default
				print("No type for quest of faction 'GOAT'.")
		pass
	elif (faction == "FJB"):
		#each of these is a different quest type
		match int(type):
			1: 
				self.progressSig = SignalBus.enemy_killed
			_: #default
				print("No type for quest of faction 'FJB'.")
		pass
	elif (faction == "SEU"):
		#each of these is a different quest type
		match int(type):
			1: 
				self.progressSig = SignalBus.rock_mined
			2: 
				self.progressSig = SignalBus.rock_mined
			_: #default
				print("No type for quest of faction 'SEU'.")
	else:
		print("No faction for quest")
	
func activate():
	self.progressSig.connect(update_progress)
	
func deactivate():
	self.progressSig.disconnect(update_progress)

#called everytime the signal is caught 
func update_progress(killer:CollisionObject2D):
	#print("quest triggered, progress:",progress,"/",total)
	if progress < total:
		progress += 1
		SignalBus.quest_progressed.emit()
	if progress == total:
		SignalBus.quest_completed.emit()
	# else do nothing

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
