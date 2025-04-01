extends Node

#Player name
@export var playerName : String = "player_0"
@export var playerID : int = 0

#Ship stats
@export var dash_cd = 1.0

#Ship resources
@export var quest = null
@export var credits = 0
@export var totalScore = 0

#moved to ship
#var shielded (bool)
#var knockback (bool)
#var dash (bool)
#var dash_mult (int)
#var dash_length (float)
#var health (int)

# Called upon respawning
func reset():
	# Reset name and ID
	playerName = "player_0"
	
	# Ship stats
	dash_cd = 1.0
	
	# Ship resources
	credits = 0
	totalScore = 0
	
	# Ship Quest deactivation logic
	if quest != null:
		quest.deactivate()
		quest = null
