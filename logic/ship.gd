extends CharacterBody2D

@export var speed = 300
@export var rotation_speed = 3
@export var dash_speed = 900
@export var dash_length = 0.3
@export var push_force = 80

@onready var dash = $dashtimer
var rotation_direction = 0

func get_input():
	if Input.is_action_pressed("dash"):
		dash.start_dash(dash_length)
	rotation_direction = 0 if dash.is_dashing() else Input.get_axis("left", "right")
	velocity = transform.y * -Input.get_action_strength("up") * dash_speed if dash.is_dashing() else transform.y * -Input.get_action_strength("up") * speed
	

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta

	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
			
	move_and_slide()
