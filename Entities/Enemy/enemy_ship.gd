extends CharacterBody2D

@export var playerName = "BOT"

@onready var nameLabel = $Name_Label
@onready var action = $Action_Timer
@onready var dash = $Dash_Cooldown
@onready var shield = $Shield
@onready var vision = $Vision
var iframes = 0 # Put a timer here I need to ask how to set that up
var speed = 300
var rotation_speed = 3
var dash_speed = 900
var dash_length = 0.3
var dash_cd = 0.5
var knock_back_time = 0.3
var rotation_direction = 0
var health = 2
var maxHealth = 2

var knockback = false
var dashing = false
var shielded = false

signal bounty_claimed(killer)

var randomizer = RandomNumberGenerator.new()

func _enter_tree() -> void:
	$MultiplayerSynchronizer.set_multiplayer_authority(0)
	#self.add_to_group("Enemies")
	$Lance.deactivate()
	$Shield.activate()

func enemy_logic_process():
	if health >= 1:
		var front_object = vision.get_node("Front").get_collider()
		var left_object = vision.get_node("Left").get_collider()
		var right_object = vision.get_node("Right").get_collider()
		
		if front_object != null:
			if front_object is CharacterBody2D:
				start_dash()
			else:
				#rotation_direction = randomizer.randi_range(-1,1)
				turn_right()
		else:
			rotation_direction = 0
			
		#turn if there is object too close to its side
		if left_object != null: turn_right()
		if right_object != null: turn_left()
		
		#dash if there is a ship behind
		if len(vision.get_node("Back").get_overlapping_bodies()) > 1: 
			start_dash()
		if !action.is_in_action():
			velocity = transform.y * -speed
		pass
	
#start dash if not knocked back or currently dashing	
func start_dash():
	if !dash.is_in_cd() and knockback == false:
		action.start_dash(dash_length)
		dash.start_cd(dash_cd)
		rotation_direction = 0
		velocity = -transform.y * dash_speed 
		$Lance.activate()
		
func turn_left():
	rotation_direction -= 1
	
func turn_right():
	rotation_direction += 1

func _physics_process(delta):
	enemy_logic_process()
	rotation += clamp(rotation_direction,-1,1) * rotation_speed * delta
	nameLabel.set_rotation(-1 * rotation)

	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * 10)
			
	if get_slide_collision_count() != 0:
		action.start_knockback(knock_back_time)
		velocity = velocity.bounce(get_slide_collision(0).get_normal())
			
	move_and_slide()
	
func get_knockback():
	action.start_knockback(knock_back_time)
	velocity = -velocity


# This function handles taking damage.
func take_damage(attacker: CollisionObject2D) -> bool:
	if not shield.in_iframe:
		health -= 1
		if health < 1:
			death(attacker)
		
	return true if health<=0 else false

# This function handles when the player reaches 0 HP.
func death(killer: CollisionObject2D):
	# Need a better solution for how to freeze player inputs
	queue_free()
	SignalBus.enemy_killed.emit(killer)
	bounty_claimed.emit(killer)
	pass

func is_local_authority():
	return false

#func _on_dmg_rock_took_damage() -> void:
	#take_damage()
