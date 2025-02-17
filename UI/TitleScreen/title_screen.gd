extends CanvasLayer

#all this script does right now is 
# • navigate to the mainspace on button press 
# • allow the user to put in a userName

@export var playerName: String

var peer = ENetMultiplayerPeer.new()
var address = "localhost" # <-- CHANGE THIS WITH "0.0.0.0" IP LATER  
var port = 5040 # <-- CHANGE THIS WITH OUR PORT LATER 

@export var player_scene : PackedScene

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

func _add_player(id):
	print("_add_player "+str(id))
	assign_player_name()
	
	var tree = get_tree()
	tree.change_scene_to_packed(load("res://mainspace.tscn"))
	#tree.root.add_child(load("res://mainspace.tscn").instantiate())
	tree.root.add_child(player_scene.instantiate())
	
	#var player = player_scene.instantiate()
	#call_deferred("add_child", player)

func peer_disconnected(id):
	print("peer disconnected "+str(id))
	GameManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free()

func connected_to_server():
	print("connected to server!")
	#sendPlayerInformation()

func connection_failed():
	print("cannot connect")

func _on_play_button_pressed() -> void:
	assign_player_name()
	get_tree().change_scene_to_file("res://mainspace.tscn")

func _on_host_button_pressed() -> void:
	var error = peer.create_server(port, 2)
	#making sure the peer is able to host
	if error != OK:
		print("cannot host: " + str(error)) 
		return
	
	#compression helps with bandwith usage vvv
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	#creating the first peer with the host we created already 
	multiplayer.multiplayer_peer = peer
	
	print("hosting game")
	_add_player(1)

func _on_join_button_pressed() -> void:
	peer.create_client(address, port)
	print("joining game")
	#compression helps with bandwith usage vvv
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer

#small function to assign shipData playerName to the class playerName
func assign_player_name():
	if !playerName.is_empty():
		ShipData.playerName = playerName
	else:
		ShipData.playerName = "player_"+ str(rng.randi_range(0,1000))

func _on_line_edit_text_changed(new_text: String) -> void:
	playerName = new_text

func _on_lb_button_pressed() -> void:
	$Home.visible = false
	$Leaderboard.visible = true

func _on_back_button_pressed() -> void:
	$Leaderboard.visible = false
	$Home.visible = true
