extends Node2D

@export var player_scene = preload("res://Entities/Ship/ship.tscn")
@onready var spawn_area = $PlayerSpawnArea
signal player_created(id)

func _ready():
	
	if NetworkState.is_server:
		# Listen to peer connections, and create new ship for them
		multiplayer.peer_connected.connect(spawn_player)
		# Listen to peer disconnections, and remove their ships
		multiplayer.peer_disconnected.connect(remove_player)
	else:
		# Listen for new player's ID and name once they connect
		player_created.connect(set_up_player)

func spawn_player(id: int) -> void:
	await get_tree().create_timer(1.0).timeout
	$PlayerSpawner.spawn(id)
	# Set player spawn position
	set_player_position.rpc(id, spawn_area.position)
	# Server tells player to finish their set-up
	new_player_created.rpc_id(id, id)
	# Server tells all clients to add new player to their enemy lists
	add_to_enemy_list.rpc(id)

func remove_player(id: int) -> void:
	# Delete this player's node.
	$Players.get_node(str(id)).queue_free()

@rpc("call_local")
func set_player_position(id, spawn_position):
	var player = get_node("Players/%s" % id)
	player.global_position = spawn_position
	
func ship_nearby(overlapping_bodies):
	for body in overlapping_bodies:
		if body is CharacterBody2D or body.has_method("_on_shop_area_entered"):
			return true
	return false

@rpc("any_peer")
func new_player_created(id):
	player_created.emit(id)

func set_up_player(id):
	# Have new Player set their own display name
	#print("Player created, setting their name")
	$Players.get_node(str(id)).set_player_name(ShipData.playerName)
	#print("Set ", id, " to ", ShipData.playerName)
	#print("Confirming name: ", $Players.get_node(str(id)).playerName)
	SignalBus.player_finished_setup.emit()
	# Have new Player set up their own Enemies list
	set_up_enemy_list()

# For the newest client only
func set_up_enemy_list():
	var listOfPlayers = $Players.get_children()
	var listOfBots = $Bots.get_children()
	
	var myID = multiplayer.get_unique_id()
	listOfPlayers.erase($Players.get_node(str(myID)))
	
	# Add all other existing players to Enemies group
	for p in listOfPlayers:
		p.add_to_group("Enemies")
	for b in listOfBots:
		b.add_to_group("Enemies")

@rpc("any_peer", "call_local")
func add_to_enemy_list(id):
	var myID = multiplayer.get_unique_id()
	if id != myID:
		$Players.get_node(str(id)).add_to_group("Enemies")

func _physics_process(_delta: float) -> void:
	if NetworkState.is_server:
		if ship_nearby(spawn_area.get_overlapping_bodies()):
			var buffer = 200 # So that it doesn't spawn on top of border
			var right_edge = $MapBorder/BottomBorderCollisionShape.position.x
			var bottom_edge = $MapBorder/BottomBorderCollisionShape.position.y
			spawn_area.global_position = Vector2(randf_range(buffer, right_edge - buffer), randf_range(buffer, bottom_edge - buffer))
