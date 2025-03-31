extends CharacterBody2D

const gameOverScreen = preload("res://UI/GameOverScreen/game_over_screen.tscn")

@export var playerName : String = "player_0"
@export var health = 2
@export var maxHealth = 2

signal bounty_claimed(killer)

@onready var nameLabel = $Name_Label
@onready var camera = $Camera2D
@onready var action = $Action_Timer
@onready var dash_cd_timer = $Dash_Cooldown
@onready var shield = $Shield
@onready var iframes = 0 # Put a timer here I need to ask how to set that up

var regenerting_dash = false

var rotation_direction = 0
var rotation_speed = 3
var dash_mult = 3
var dash_length = 0.3

var speed = 300
var dash_cd = 1.0
var knock_back_time = 0.3

#Ship states
var shielded = false
var regenerating_dash = false
var knockback = false
var dash = false

func _enter_tree() -> void:
	self.set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	if is_local_authority():
		camera.make_current()
		shield.activate()
		SignalBus.quest_received.connect(_on_quest_received)
		SignalBus.upgrade_special.connect(upgrade_bought)
		SignalBus.enemy_killed.connect(killed_enemy_reward)
		SignalBus.show_indicator_arrow.connect(enable_indicator_arrow)
		SignalBus.show_quest_timer.connect(enable_quest_timer_bar)

func is_local_authority():
	return self.get_multiplayer_authority() == multiplayer.get_unique_id()

func set_player_name(playerName):
	if is_local_authority():
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
func take_damage(myAttacker: CollisionObject2D):
	if is_local_authority():
		if not shield.in_iframe:
			self.health -= 1
			SignalBus.damage_taken.emit(self)
			if self.health < 1:
				death(myAttacker)
			
func dash_regen():
	if is_local_authority():
		action.stop()
		SignalBus.dash_regen.emit()

# This function handles when the player reaches 0 HP.
func death(myKiller: CollisionObject2D):
	if is_local_authority():
		broadcast_player_died.rpc(str(myKiller.name))
		self.visible = false
		self.set_collision_layer_value(1, false)
		self.set_collision_mask_value(1, false)
		
		SignalBus.player_died.emit(ShipData.totalScore)

@rpc("any_peer")
func broadcast_player_died(killerID):
	# Bots and damage rocks will never have a quest, so there is no point emitting the enemy_killed or bounty_claimed signals since they are only used for quests
	if not killerID.containsn("BOT") and not killerID.containsn("DmgRock"):
		var killer = get_node("/root/Game/Players/%s" % killerID)
		bounty_claimed.emit(killer)
		SignalBus.enemy_killed.emit(killer)

# Rewards player with a flat 5 credits for killing anything
func killed_enemy_reward(killer):
	if is_local_authority() and killer == self:
		ShipData.credits += 5
		ShipData.totalScore += 5
		SignalBus.credits_updated.emit()
		SignalBus.score_updated.emit()
		

func energy_station_eligible():
	pass

func shop_entered():
	if is_local_authority():
		$Hurtbox.isEnabled = false

func shop_exited():
	if is_local_authority():
		$Hurtbox.isEnabled = true
		# had to add this line because when you buy upgraded shields,
		# it just increases your max health but doesn't reset it.
		self.health = self.maxHealth
		shield.activate()

func _on_quest_received(q: Quest) -> void:
	if is_local_authority():
		ShipData.quest = q
		q.holder = self
		add_child(ShipData.quest)
		ShipData.quest.activate()
	
func enable_quest_timer_bar():
	if is_local_authority():
		$QuestTimerBar.enable_timer_bar()	
func enable_indicator_arrow(target: CollisionObject2D):
	if is_local_authority():
		$Indicator_Arrow.enable_indicator_arrow(target)

func upgrade_bought(id:int, value):
	if is_local_authority():
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
			
