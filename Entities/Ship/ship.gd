extends CharacterBody2D

const gameOverScreen = preload("res://UI/GameOverScreen/gameOverScreen.tscn")

@onready var nameLabel = $Name_Label
@onready var action = $Action_Timer
@onready var dash = $Dash_Cooldown
@onready var shield = $Shield
@onready var iframes = 0 # Put a timer here I need to ask how to set that up

var upgradeIDtoFunc = {
	4:upgradeRegenHit
	}

var shielded = false
var regenerting_dash = false

var rotation_direction = 0

func _ready() -> void:
	SignalBus.damage_taken.connect(_on_dmg_rock_took_damage)
	SignalBus.quest_received.connect(_on_quest_received)
	SignalBus.upgrade_special.connect(upgrade_bought)
	nameLabel.text = ShipData.playerName
	shield.activate()

func get_input():
	if ShipData.health > 0:
		if Input.is_action_pressed("dash") and !dash.is_in_cd() and ShipData.knockback == false:
			action.start_dash(ShipData.dash_length)
			dash.start_cd(ShipData.dash_cd)
			rotation_direction = 0
			velocity = -transform.y * ShipData.speed * ShipData.dash_mult
			$Lance.activate()
		
		if !ShipData.dash:
			rotation_direction = Input.get_axis("left", "right")
			$Lance.deactivate()
			
		if !action.is_in_action():
			velocity = transform.y * -Input.get_action_strength("up") * ShipData.speed
	else: # Player is dead and cannot move anymore
		velocity = transform.y * 0
		rotation_direction = 0

func upgradeRegenHit():
	regenerting_dash = true

func _physics_process(delta):
	if owner.is_multiplayer_authority():
		get_input()
		rotation += rotation_direction * ShipData.rotation_speed * delta
		nameLabel.set_rotation(-1 * rotation)

		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			if c.get_collider() is RigidBody2D:
				c.get_collider().apply_central_impulse(-c.get_normal() * 10)
				
		if get_slide_collision_count() != 0 and not regenerting_dash:
			action.start_knockback(ShipData.knock_back_time)
			velocity = velocity.bounce(get_slide_collision(0).get_normal())
				
	move_and_slide()

# This function handles taking damage.
# Note: Put timer here for i-frames.
func take_damage(attacker: CollisionObject2D):
	if not shield.in_iframe:
		ShipData.health -= 1
		if ShipData.health < 1:
			death(attacker)
			
func dash_regen():
	action.stop()
	SignalBus.dash_regen.emit()

# This function handles when the player reaches 0 HP.
func death(attacker: CollisionObject2D):
	queue_free()
	SignalBus.player_died.emit(ShipData.totalScore)

func _on_dmg_rock_took_damage(attacker) -> void:
	take_damage(attacker)

func shop_entered():
	$Hurtbox.isEnabled = false

func shop_exited():
	$Hurtbox.isEnabled = true
	# had to add this line because when you buy upgraded shields,
	# it just increases your max health but doesn't  reset it.
	ShipData.health = ShipData.maxHealth 

func _on_quest_received(q: Variant) -> void:
	ShipData.quest = q
	q.holder = self
	ShipData.quest.activate()
	add_child(ShipData.quest)
	
func upgrade_bought(id:int):
	if upgradeIDtoFunc.has(id):
		upgradeIDtoFunc[id].call()

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
