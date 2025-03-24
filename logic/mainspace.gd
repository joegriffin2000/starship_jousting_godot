extends Node2D

@export var player_scene = preload("res://Entities/Ship/ship.tscn")
signal player_created(id)
@onready var spawn_area = $Players/SpawnArea

func _ready():
	#$PlayerSpawner.spawn_function = spawn_player
	if NetworkState.is_server:
		# Listen to peer connections, and create new ship for them
		multiplayer.peer_connected.connect(spawn_player)
		# Listen to peer disconnections, and remove their ships
		multiplayer.peer_disconnected.connect(remove_player)
		
	else:
		# Listen for new player's ID and name once they connect
		player_created.connect(set_new_player_name)

@rpc("any_peer", "call_local")
func newPlayerCreated(id):
	player_created.emit(id)

func spawn_player(id: int) -> void:
	# Instantiate a new player for this client.
	var player = player_scene.instantiate()
	# Set the name, so players can figure out their local authority
	player.name = str(id)
	# Add player to scene tree
	#$PlayerSpawner.spawn(id)
	$Players.add_child(player)
	set_player_position.rpc(id, spawn_area.position)
	newPlayerCreated.rpc_id(id, id)
	
func _physics_process(delta: float) -> void:
	if NetworkState.is_server:
		if ship_nearby(spawn_area.get_overlapping_bodies()):
			var buffer = 50 # So that it doesn't spawn on top of border
			var right_edge = $MapBorder/BottomBorderCollisionShape2.global_position.x
			var bottom_edge = $MapBorder/BottomBorderCollisionShape2.global_position.y
			spawn_area.global_position = Vector2(randf_range(buffer, right_edge - buffer), randf_range(buffer, bottom_edge - buffer))
	
@rpc("call_local")
func set_player_position(id, spawn_position):
	print("called")
	var player = get_node("Players/%s" % id)
		
	player.position = spawn_position
	
func ship_nearby(overlapping_bodies):
	for body in overlapping_bodies:
		if body is CharacterBody2D:
			return true
	return false
	
func remove_player(id: int) -> void:
	# Delete this player's node.
	$Players.get_node(str(id)).queue_free()

func set_new_player_name(id):
	print("Player created, setting their name")
	#$Players.get_node(str(id)).set_player_name(ShipData.playerName)
	print("Set ", id, "to ", ShipData.playerName)
