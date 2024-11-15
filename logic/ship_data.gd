extends Node

#Player name
@export var playerName : String = "player_0"

#Ship stats
@export var speed = 300
@export var rotation_speed = 3
@export var dash_speed = speed * 3
@export var dash_length = 0.3
@export var dash_cd = 0.5
@export var knock_back_time = 0.3

#Ship resources
@export var health = 1
@export var quest = null
@export var credits = 0
@export var totalScore = 0
@export var rocks = 0

#Ship states
@export var knockback = false
@export var dash = false

# Called upon respawning
func reset():
	# Ship stats
	speed = 300
	rotation_speed = 3
	dash_speed = speed * 3
	dash_length = 0.3
	dash_cd = 0.5
	knock_back_time = 0.3
	
	# Ship resources
	credits = 0
	health = 1
	totalScore = 0

	# Ship states
	knockback = false
	dash = false
	
	# Ship Quest deactivation logic
	if quest != null:
		quest.deactivate()
		quest = null
