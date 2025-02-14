extends CanvasLayer

#all this script does right now is 
# • navigate to the mainspace on button press 
# • allow the user to put in a userName

@export var playerName: String

var peer = ENetMultiplayerPeer.new()
var address = "localhost" # <-- CHANGE THIS WITH OUR IP LATER 
var port = 5040 # <-- CHANGE THIS WITH OUR PORT LATER 

@export var player_scene = load("res://mainspace.tscn")

var rng = RandomNumberGenerator.new()

func _on_play_button_pressed() -> void:
	if !playerName.is_empty():
		ShipData.playerName = playerName
	else:
		ShipData.playerName = "player_"+ str(rng.randi_range(0,1000))
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
	
	multiplayer.peer_connected.connect(_add_player)
	
	_add_player()
	print("hosting game")
	
func _add_player(id = 1):
	print("_add_player")
	
	if !playerName.is_empty():
		ShipData.playerName = playerName
	else:
		ShipData.playerName = "player_"+ str(rng.randi_range(0,1000))
	
	get_tree().change_scene_to_packed(player_scene)
	var player = player_scene.instantiate()
	print("player:",player)
	call_deferred("add_child", player)

func _on_join_button_pressed() -> void:
	peer.create_client(address, port)
	
	print("joining game")
	#compression helps with bandwith usage vvv
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.multiplayer_peer = peer


func _on_line_edit_text_changed(new_text: String) -> void:
	playerName = new_text

func _on_lb_button_pressed() -> void:
	$Home.visible = false
	$Leaderboard.visible = true

func _on_back_button_pressed() -> void:
	$Leaderboard.visible = false
	$Home.visible = true
