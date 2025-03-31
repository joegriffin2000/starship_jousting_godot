extends CanvasLayer

#all this script does right now is 
# • navigate to the mainspace on button press 
# • allow the user to put in a userName

@export var player_name: String
@export var map_scene: PackedScene

#var ip = "wss://starshipjousting.space"
var ip = "localhost"
var port = 2302
var rng = RandomNumberGenerator.new()
var regex = RegEx.new()

func _ready():
	if "--server" in OS.get_cmdline_args():
		NetworkState.start_network(true)
		load_scene()

# Assigns the playerName to the ShipData playerName upon game start
func assign_player_name():
	regex.compile("([^A-Za-z0-9_])+")
	if player_name.is_empty() or regex.search(player_name) != null: # If no or invalid playerName, assign a random one
		player_name = "player_"+ str(rng.randi_range(1,999))
		print("No player name; assigned name ", player_name)
	elif player_name.length() > 10: # If name is too long (10 character maximum), truncate it. Random player names will always be within the limit
		player_name = player_name.left(10)
	ShipData.playerName = player_name

# Updates playerName to inputted text
func _on_line_edit_text_changed(new_text: String) -> void:
	player_name = new_text

# Loads the map
func load_scene():
	get_tree().change_scene_to_packed(map_scene)

# Play game button, joins the server
func _on_play_button_pressed() -> void:
	assign_player_name() # Makes sure we have a name
	NetworkState.start_network(false, ip, port)
	#await multiplayer.connected_to_server
	load_scene()

# Displays leaderboard
func _on_lb_button_pressed() -> void:
	$Home.visible = false
	$Leaderboard.visible = true

# Displays start menu again
func _on_back_button_pressed() -> void:
	$Leaderboard.visible = false
	$Home.visible = true

	
