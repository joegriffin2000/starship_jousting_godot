extends VBoxContainer

@onready var rows = [
		$First,
		$Second,
		$Third,
		$Fourth,
		$Fifth
	]
@onready var you = $You
@onready var div = $Divider
var myID

@export var playersAndScores = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.score_updated.connect(update_lb)
	multiplayer.peer_disconnected.connect(remove_player_from_lb)
	
	myID = multiplayer.get_unique_id()
	playersAndScores.append([myID, ShipData.playerName, 0])
	
	display_top_5.rpc()
	check_you_visible()

func remove_player_from_lb(id):
	# Update my score in playersAndScores
	for i in range(len(playersAndScores)):
		if id == playersAndScores[i][0]:
			playersAndScores.pop_at(i)
			break
	display_top_5()

@rpc("any_peer", "call_local")
func check_you_visible():
	var inTop5 = false
	var num = 5 if len(playersAndScores) > 5 else len(playersAndScores)
	for i in range(num):
		if playersAndScores[i][0] == myID:
			inTop5 = true
			break
	if not(inTop5):
		set_you_visible()
	
# Show the player in the You spot
func set_you_visible():
	you.get_node_and_resource("MarginContainer/HBoxContainer/PlayerName")[0].text = str(ShipData.playerName, "  ")
	you.get_node_and_resource("MarginContainer/HBoxContainer/Score")[0].text = str(ShipData.totalScore)
	div.visible = true
	you.visible = true

@rpc("any_peer", "call_local")
func display_top_5():
	# Set top 5, or less than top 5 if less than 5 players
	var num = 5 if len(playersAndScores) > 5 else len(playersAndScores)
	
	for i in range(num):
		rows[i].get_node_and_resource("MarginContainer/HBoxContainer/PlayerName")[0].text = str(playersAndScores[i][1])
		rows[i].get_node_and_resource("MarginContainer/HBoxContainer/Score")[0].text = str(playersAndScores[i][2])
		
		rows[i].visible = true

func update_lb():
	# Update my score in playersAndScores
	for player in playersAndScores:
		if myID == player[0]:
			player[2] = ShipData.totalScore
			break
	
	# Re-sort playersAndScores
	playersAndScores.sort_custom(func(a, b): return a[2] > b[2])
	
	display_top_5()
