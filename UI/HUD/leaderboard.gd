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

@onready var TempPlayers = {
	12343: {
		"name":"joe",
		"score":121
	},
	33421: {
		"name":"ben",
		"score":103
	},
	43321: {
		"name":"finn",
		"score":123
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.score_updated.connect(update_lb)
	div.visible = true
	you.visible = true
	update_lb()

# Temporary function used for testing while not using the the GameManager.Players dictionary
# This function shouldn't be necessary if we keep GameManager up to date with everyone's scores on change
func add_me():
	if TempPlayers.has(multiplayer.get_unique_id()):
		TempPlayers[multiplayer.get_unique_id()]["score"] = ShipData.totalScore
	else:
		TempPlayers[multiplayer.get_unique_id()] = {
			"name":ShipData.playerName,
			"score":ShipData.totalScore
		}

func update_lb():
	#updating score in TempPlayers. Shouldn't be necessary when we have GameManager.Players updating with scores
	add_me()
	
	#this is made in a way where you could just plug in GameManager.Players 
	#and it will work
	var players = TempPlayers.duplicate()
	#var players = GameManager.Players.duplicate()
	
	you.get_node_and_resource("MarginContainer/HBoxContainer/PlayerName")[0].text = str(ShipData.playerName, "  ")
	you.get_node_and_resource("MarginContainer/HBoxContainer/Score")[0].text = str(ShipData.totalScore)
	
	var num = 5 if len(players) > 5 else len(players)
	
	for k in range(num):
		var id = 0
		var currentMax = -1
		for i in players:
			if players[i]["score"] > currentMax:
				currentMax = players[i]["score"]
				id = i
				
		rows[k].get_node_and_resource("MarginContainer/HBoxContainer/PlayerName")[0].text = str(players[id]["name"])
		rows[k].get_node_and_resource("MarginContainer/HBoxContainer/Score")[0].text = str(players[id]["score"])
		
		players.erase(id)
		
		rows[k].visible = true
		
		# if the player is already on the leaderboard, 
		# hide the "you" box and the divider.
		if multiplayer.get_unique_id() == id:
			div.visible = false
			you.visible = false
