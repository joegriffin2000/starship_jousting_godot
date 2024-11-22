extends VBoxContainer

#@onready var first = $First
#@onready var second = $Second
#@onready var third = $Third
#@onready var fourth = $Fourth
#@onready var fifth = $Fifth
#@onready var sixth = $Sixth
#@onready var seventh = $Seventh
#@onready var eighth = $Eighth
#@onready var ninth = $Ninth
#@onready var you = $You
@onready var div = $Divider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.score_updated.connect(update_lb)
	update_lb() # Update LB once to show initial state

# Logic to update the leaderboard.
func update_lb() -> void:
	# TODO: Display more than just the player.
	# Future code should be:
	# Display first 10 scores from get_multiplayer_scores()
	# If one of them is the player, hide div and you
	# Else display player in div and you
	# In small servers, hide scores that aren't set (check len of get_multiplayer_scores(), if < 9 then hide variables accordingly)
	
	$First/MarginContainer/HBoxContainer/PlayerName.text = str(ShipData.playerName, "  ")
	$First/MarginContainer/HBoxContainer/Score.text = str(ShipData.totalScore)

# TODO: For multiplayer implementation.
# Get all the names + scores from all players (object?)
# Store them in an array
# Sort the array in reverse (largest score at index 0)
# Return the array of players + scores
func get_multiplayer_scores():
	pass
