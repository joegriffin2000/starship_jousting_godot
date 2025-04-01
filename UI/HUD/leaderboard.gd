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

func _ready() -> void:
	if NetworkState.is_server: # Server
		multiplayer.peer_disconnected.connect(remove_player_from_lb)
	else: # Clients
		SignalBus.score_updated.connect(update_my_score)
		await SignalBus.player_finished_setup
		myID = multiplayer.get_unique_id()
		new_player_created.rpc_id(1, myID, ShipData.playerName)

# Called on server by new client
@rpc("any_peer", "call_remote")
func new_player_created(id, playerName):
	playersAndScores.append([id, playerName, 0])
	set_client_players_and_scores.rpc(playersAndScores)
	display_top_5()

# Called on all clients by server
@rpc("any_peer", "call_remote")
func set_client_players_and_scores(psList):
	playersAndScores = psList
	check_you_visible()
	
# Called on server upon client disconnection
func remove_player_from_lb(id):
	for i in range(len(playersAndScores)):
		if id == playersAndScores[i][0]:
			playersAndScores.pop_at(i)
			break
	set_client_players_and_scores.rpc(playersAndScores)
	display_top_5()

# Called on server
func display_top_5():
	for i in range(5):
		if i < len(playersAndScores):
			rows[i].set_lb_item.rpc(str(playersAndScores[i][1]), playersAndScores[i][2])
		else:
			rows[i].hide_item.rpc()

# Called on clients
func check_you_visible():
	var inTop5 = false
	var num = 5 if len(playersAndScores) > 5 else len(playersAndScores)
	for i in range(num):
		if playersAndScores[i][0] == myID:
			inTop5 = true
			break
	if not(inTop5):
		set_you_visible()
func set_you_visible():
	you.set_lb_item(str(ShipData.playerName, "  "), ShipData.totalScore)
	div.visible = true
	you.visible = true

# Called on clients upon receiving score_updated signal
func update_my_score():
	update_lb.rpc_id(1, myID, ShipData.totalScore)

# Called on server by clients
@rpc("any_peer", "call_remote")
func update_lb(id, score):
	print(str(playersAndScores))
	
	# Update received player's score in playersAndScores
	for player in playersAndScores:
		if id == player[0]:
			player[2] = score
			break
	
	# Re-sort playersAndScores
	playersAndScores.sort_custom(func(a, b): return a[2] > b[2])
	
	# Send all clients the new playersAndScores list
	set_client_players_and_scores.rpc(playersAndScores)
	
	# Re-display the top 5
	display_top_5()
