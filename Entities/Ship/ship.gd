extends CharacterBody2D

const gameOverScreen = preload("res://UI/GameOverScreen/game_over_screen.tscn")

@export var playerName : String = "player_0"

@onready var nameLabel = $Name_Label
@onready var camera = $Camera2D
@onready var action = $Action_Timer
@onready var dash_cd_timer = $Dash_Cooldown
@onready var shield = $Shield
@onready var iframes = 0

var rotation_direction = 0
var rotation_speed = 3
var dash_mult = 3
var dash_length = 0.3
var health = 2

var speed = 300
var dash_cd = 1.0
var knock_back_time = 0.3
var maxHealth = 2

#Ship states
var shielded = false
var regenerating_dash = false
var knockback = false
var dash = false

func _ready() -> void:
	SignalBus.damage_taken.connect(_on_dmg_rock_took_damage)
	SignalBus.quest_received.connect(_on_quest_received)
	SignalBus.upgrade_special.connect(upgrade_bought)
	shield.activate()
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if is_local_authority():
		camera.make_current()

func is_local_authority():
	return $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()

func set_player_name(playerName):
	self.playerName = playerName
	nameLabel.text = self.playerName

func get_input():
	if is_local_authority():
		if health > 0:
			if Input.is_action_pressed("dash") and !dash_cd_timer.is_in_cd() and knockback == false:
				action.start_dash(dash_length)
				dash_cd_timer.start_cd(dash_cd)
				rotation_direction = 0
				velocity = -transform.y * speed * dash_mult
				$Lance.activate()
			
			if !dash:
				rotation_direction = Input.get_axis("left", "right")
				$Lance.deactivate()
				
			if !action.is_in_action():
				velocity = transform.y * -Input.get_action_strength("up") * speed
		else: # Player is dead and cannot move anymore
			velocity = transform.y * 0
			rotation_direction = 0

func _physics_process(delta):
	if is_local_authority():
		get_input()
		rotation += rotation_direction * rotation_speed * delta
		nameLabel.set_rotation(-1 * rotation)
		$QuestTimerBar.set_rotation(-1 * rotation)

		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			if c.get_collider() is RigidBody2D:
				c.get_collider().apply_central_impulse(-c.get_normal() * 10)
				
		if get_slide_collision_count() != 0 and not regenerating_dash:
			action.start_knockback(knock_back_time)
			velocity = velocity.bounce(get_slide_collision(0).get_normal())
				
		move_and_slide()

# This function handles taking damage.
# Note: Put timer here for i-frames.
func take_damage(attacker: CollisionObject2D):
	if not shield.in_iframe:
		health -= 1
		if health < 1:
			death(attacker)
			
func dash_regen():
	action.stop()
	SignalBus.dash_regen.emit()

# This function handles when the player reaches 0 HP.
func death(_attacker: CollisionObject2D):
	if is_local_authority():
		queue_free()
		SignalBus.player_died.emit(ShipData.totalScore)

func _on_dmg_rock_took_damage(attacker) -> void:
	take_damage(attacker)

func energy_station_eligible():
	pass

func shop_entered():
	$Hurtbox.isEnabled = false

func shop_exited():
	$Hurtbox.isEnabled = true
	# had to add this line because when you buy upgraded shields,
	# it just increases your max health but doesn't  reset it.
	health = maxHealth 

func _on_quest_received(q: Variant) -> void:
	if is_local_authority():
		ShipData.quest = q
		q.holder = self
		ShipData.quest.activate()
		add_child(ShipData.quest)
	
func upgrade_bought(id:int,value):
	#this is a janky fix
	match id:
		0:
			speed += value
		1:
			knock_back_time += value
		2:
			dash_cd += value
		3:
			maxHealth += value
		4:
			regenerating_dash = true
		_:
			pass
			
