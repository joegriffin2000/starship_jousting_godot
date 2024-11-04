class_name Quest

@export var faction : String #type of faction ("FJB","SEU","GOAT")
@export var description : String #quick description of quest
@export var type : int #type of faction quest (1,2,3,...)
@export var total : int #number requirement for quest completion
@export var progress : int #number progress for quest completion

# Called when the node enters the scene tree for the first time.

#I DONT KNOW IF THIS IS WHERE THIS BELONGS
func _ready() -> void:
	if (faction == "goat"):
		#each of these is a different quest type
		match type:
			1: 
				#SignalBus.rock_mined.connect(update_progress)
				pass 
			2: 
				#SignalBus.rock_mined.connect(update_progress)
				pass
			_: #default
				print("No type for quest of faction 'goat'.")
		pass
	elif (faction == "fjb"):
		#each of these is a different quest type
		match type:
			1: 
				#SignalBus.rock_mined.connect(update_progress)
				pass 
			_: #default
				print("No type for quest of faction 'fjb'.")
		pass
	elif (faction == "seu"):
		#each of these is a different quest type
		match type:
			1: 
				#SignalBus.rock_mined.connect(update_progress)
				pass 
			2: 
				#SignalBus.rock_mined.connect(update_progress)
				pass
			_: #default
				print("No type for quest of faction 'seu'.")
	else:
		print("No faction for quest")

#called everytime the signal is caught 
func update_progress():
	if progress != total:
		progress += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
