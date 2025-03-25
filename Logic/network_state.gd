extends Node2D

var is_server := false
var peer = ENetMultiplayerPeer.new()

func start_network(server: bool, ip: String = "", port: int = 5040) -> void:
	is_server = server
	if server:
		peer.create_server(port)
		print("Server listening on port ", port)
		multiplayer.peer_connected.connect(player_connected)
		multiplayer.peer_disconnected.connect(player_disconnected)
	else:
		print("Connecting...")
		peer.create_client(ip, port)
		multiplayer.connected_to_server.connect(_on_connection_success)
		multiplayer.connection_failed.connect(_on_connection_failed)
	
	# Compression for improved bandwidth usage
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)

func disconnect_me():
	if not is_server:
		multiplayer.connected_to_server.disconnect(_on_connection_success)
		multiplayer.connection_failed.disconnect(_on_connection_failed)
	peer.close()

# Called on ALL peer connections
func player_connected(id):
	print("Peer connected: ", str(id))

# Called on ALL peer disconnects
func player_disconnected(id):
	print("Peer disconnected: ", str(id))

# Called on CLIENT when client peer fails to connect to server
func _on_connection_failed():
	print("Failed to connect.")
	get_tree().change_scene_to_file("res://UI/TitleScreen/title_screen.tscn")

# Called on CLIENT when client peer successfully connects to server
func _on_connection_success():
	print("Connected to server!")
