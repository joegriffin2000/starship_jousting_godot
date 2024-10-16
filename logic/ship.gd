extends CharacterBody2D

@onready var action = $Action_Timer
@onready var dash = $Dash_Cooldown


var rotation_direction = 0

func get_input():
	
	if Input.is_action_pressed("dash") and !dash.is_in_cd() and ShipData.knockback == false:
		action.start_dash(ShipData.dash_length)
		dash.start_cd(ShipData.dash_cd)
		rotation_direction = 0
		velocity = -transform.y * ShipData.dash_speed 
	
	if !ShipData.dash:
		rotation_direction = Input.get_axis("left", "right")
		
	if !action.is_in_action():
		velocity = transform.y * -Input.get_action_strength("up") * ShipData.speed
	

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * ShipData.rotation_speed * delta

	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * 10)
			
	if get_slide_collision_count() != 0:
		action.start_knockback(ShipData.knock_back_time)
		velocity = velocity.bounce(get_slide_collision(0).get_normal())
			
	move_and_slide()
