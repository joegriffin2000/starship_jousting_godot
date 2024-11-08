extends CharacterBody2D

const gameOverScreen = preload("res://UI/gameOverScreen.tscn")

@onready var action = $Action_Timer
@onready var dash = $Dash_Cooldown
@onready var iframes = 0 # Put a timer here I need to ask how to set that up

var rotation_direction = 0

func _ready() -> void:
	SignalBus.damage_taken.connect(_on_dmg_rock_took_damage)

func get_input():
	if ShipData.health >= 1:
		if Input.is_action_pressed("dash") and !dash.is_in_cd() and ShipData.knockback == false:
			action.start_dash(ShipData.dash_length)
			dash.start_cd(ShipData.dash_cd)
			rotation_direction = 0
			velocity = -transform.y * ShipData.dash_speed 
			$Lance.activate()
		
		if !ShipData.dash:
			rotation_direction = Input.get_axis("left", "right")
			$Lance.deactivate()
			
		if !action.is_in_action():
			velocity = transform.y * -Input.get_action_strength("up") * ShipData.speed
	else: # Player is dead and cannot move anymore
		velocity = transform.y * 0
		rotation_direction = 0

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

func shop_entered():
	pass

# This function handles taking damage.
# Note: Put timer here for i-frames.
func take_damage():
	ShipData.health -= 1
	if ShipData.health < 1:
		death()

# This function handles when the player reaches 0 HP.
func death():
	# Need a better solution for how to freeze player inputs
	SignalBus.player_died.emit(ShipData.totalScore)

func _on_dmg_rock_took_damage() -> void:
	take_damage()
