extends Node2D

@export var player_scene = preload("res://Entities/Ship/ship.tscn")
signal player_created(id)

func _ready():
	if NetworkState.is_server:
		# Listen to peer connections, and create new ship for them
		multiplayer.peer_connected.connect(create_player)
		# Listen to peer disconnections, and remove their ships
		multiplayer.peer_disconnected.connect(remove_player)
	else:
		# Listen for new player's ID and name once they connect
		player_created.connect(set_new_player_name)

@rpc("any_peer")
func newPlayerCreated(id):
	player_created.emit(id)

@rpc("any_peer", "call_local")
func addNewPlayerToGroup(id):
	$Players.get_node(str(id)).add_to_group("Players")

func create_player(id: int) -> void:
	# Instantiate a new player for this client.
	var p = player_scene.instantiate()
	# Set the name, so players can figure out their local authority
	p.name = str(id)
	# Add player to scene tree
	$Players.add_child(p)
	newPlayerCreated.rpc_id(id, id)
	addNewPlayerToGroup.rpc(id)
	
func remove_player(id: int) -> void:
	# Delete this player's node.
	$Players.get_node(str(id)).queue_free()

func set_new_player_name(id):
	print("Player created, setting their name")
	$Players.get_node(str(id)).set_player_name(ShipData.playerName)
	ShipData.player_id = id
	print("Set ", id, " to ", ShipData.playerName)
	print("Confirming name: ", $Players.get_node(str(id)).playerName)
