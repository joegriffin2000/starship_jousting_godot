extends CanvasLayer

#all this script does right now is 
# • navigate to the mainspace on button press 
# • allow the user to put in a userName

@export var playerName: String

var peer = ENetMultiplayerPeer.new()
var address = "localhost" # <-- CHANGE THIS WITH "0.0.0.0" IP LATER  
var port = 5040 # <-- CHANGE THIS WITH OUR PORT LATER 
var compressionType = ENetConnection.COMPRESS_RANGE_CODER

@export var player_scene : PackedScene

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

@rpc("any_peer")
func sendPlayerInformation(name, id):
	#print("sendPlayerInformation called, id:"+str(id))
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id": id,
			"score": 0
		}
	if multiplayer.is_server():
		for i in GameManager.Players:
			sendPlayerInformation.rpc(GameManager.Players[i].name, i)


# Called on ALL peer connections
func player_connected(id):
	print("player_connected "+str(id))

# Called on ALL peer disconnects
func peer_disconnected(id):
	print("peer disconnected "+str(id))
	GameManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("Players")
	for i in players:
		if i.name == str(id):
			i.queue_free()

# Called on CLIENT when client peer successfully connects to server
func connected_to_server():
	print("Client connected to server!")
	# Tell the host (id 1) to send new client's information
	sendPlayerInformation.rpc_id(1, playerName, multiplayer.get_unique_id())

# Called on CLIENT when client peer fails to connect to server
func connection_failed():
	print("cannot connect")

# Start server
func _on_host_button_pressed() -> void:
	assign_player_name() # Makes sure we have a name
	
	var error = peer.create_server(port, 2) # Number is allowed number of players connected at once
	if error != OK:
		print("cannot host: " + str(error)) 
		return
	
	# Compression helps with bandwith usage vvv
	peer.get_host().compress(compressionType)
	
	# Creating the first peer with the host we created already 
	multiplayer.set_multiplayer_peer(peer)
	sendPlayerInformation(playerName, multiplayer.get_unique_id())
	
	print("Hosting game")

# Multiplayer join
func _on_join_button_pressed() -> void:
	assign_player_name() # Makes sure we have a name
	
	peer.create_client(address, port)
	print("joining game")
	# Compression helps with bandwith usage vvv
	peer.get_host().compress(compressionType)
	multiplayer.set_multiplayer_peer(peer)

@rpc("any_peer", "call_local")
func startGame():
	var scene = load("res://mainspace.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
func _on_start_game_pressed() -> void:
	startGame.rpc()

# Assigns the playerName to the ShipData playerName upon game start
func assign_player_name():
	if !playerName.is_empty(): # Use the inputted playerName
		ShipData.playerName = playerName
	else: # Generate a random playerName if no name was inputted
		ShipData.playerName = "player_"+ str(rng.randi_range(0,1000))

# Singleplayer join button
func _on_play_button_pressed() -> void:
	assign_player_name()
	get_tree().change_scene_to_file("res://mainspace.tscn")

# Updates playerName to inputted text
func _on_line_edit_text_changed(new_text: String) -> void:
	playerName = new_text
	
# Displays leaderboard
func _on_lb_button_pressed() -> void:
	$Home.visible = false
	$Leaderboard.visible = true

# Displays start menu again
func _on_back_button_pressed() -> void:
	$Leaderboard.visible = false
	$Home.visible = true
