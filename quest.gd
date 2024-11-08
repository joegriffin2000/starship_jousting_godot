class_name Quest

@export var faction : String #type of faction ("FJB","SEU","GOAT")
@export var description : String #quick description of quest
@export var type : int #type of faction quest (1,2,3,...)
@export var total : int #number requirement for quest completion
@export var progress : int #number progress for quest completion

# Called when the node enters the scene tree for the first time.
func _init(faction, description, type, total) -> void:
	self.faction = faction
	self.description = description
	self.type = type
	self.total = total
	self.progress = 0
	
func _ready() -> void:
	#I DONT KNOW IF THIS LOGIC IS SUPPOSED TO GO HERE
	if (faction == "GOAT"):
		#each of these is a different quest type
		match int(type):
			1: 
				#SignalBus.rock_mined.connect(update_progress)
				pass 
			2: 
				#SignalBus.rock_mined.connect(update_progress)
				pass
			_: #default
				print("No type for quest of faction 'GOAT'.")
		pass
	elif (faction == "FJB"):
		#each of these is a different quest type
		match int(type):
			1: 
				#SignalBus.rock_mined.connect(update_progress)
				pass 
			_: #default
				print("No type for quest of faction 'FJB'.")
		pass
	elif (faction == "SEU"):
		#each of these is a different quest type
		match int(type):
			1: 
				#SignalBus.rock_mined.connect(update_progress)
				pass 
			2: 
				#SignalBus.rock_mined.connect(update_progress)
				pass
			_: #default
				print("No type for quest of faction 'SEU'.")
	else:
		print("No faction for quest")

#called everytime the signal is caught 
func update_progress():
	if progress != total:
		progress += 1
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
