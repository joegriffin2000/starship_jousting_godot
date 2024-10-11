extends CharacterBody2D

@export var speed = 300
@export var rotation_speed = 3
@export var dash_speed = 900
@export var dash_length = 1

@onready var dash = $Dash
var rotation_direction = 0

func get_input():
	rotation_direction = Input.get_axis("left", "right")
	if Input.is_action_pressed("dash"):
		dash.start_dash(dash_length)
	velocity = transform.y * -Input.get_action_strength("up") * dash_speed if dash.is_dashing() else transform.y * -Input.get_action_strength("up") * speed

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
