extends CharacterBody2D

@export var speed = 300
@export var rotation_speed = 3
@export var dash_speed = 900
@export var dash_length = 0.3
@export var dash_cd = 1
@export var knock_back_time = 0.3

@onready var action = $Action_Timer
@onready var dash = $Dash_Cooldown


var rotation_direction = 0

func get_input():
	
	if Input.is_action_pressed("dash") and !dash.is_in_cd() and action.knockback == false:
		action.start_dash(dash_length)
		dash.start_cd(dash_cd)
		rotation_direction = 0
		velocity = -transform.y * dash_speed 
	
	if !action.dash:
		rotation_direction = Input.get_axis("left", "right")
		
	if !action.is_in_action():
		velocity = transform.y * -Input.get_action_strength("up") * speed
	

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta

	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * 10)
			
	if get_slide_collision_count() != 0:
		action.start_knockback(knock_back_time)
		velocity = velocity.bounce(get_slide_collision(0).get_normal())
		
	move_and_slide()
