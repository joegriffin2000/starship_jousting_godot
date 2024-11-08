extends Node

#Ship stats
@export var speed = 300
@export var rotation_speed = 3
@export var dash_speed = 900
@export var dash_length = 0.3
@export var dash_cd = 0.5
@export var knock_back_time = 0.3
@export var health = 1

#Ship states
@export var knockback = false
@export var dash = false

#Ship resources
@export var credits = 0
@export var rocks = 0
@export var totalScore = 100

func reset():
	speed = 300
	rotation_speed = 3
	dash_speed = 900
	dash_length = 0.3
	dash_cd = 0.5
	knock_back_time = 0.3

	#Ship states
	knockback = false
	dash = false

	#Ship resources
	credits = 0
	health = 1
	totalScore = 100
	
