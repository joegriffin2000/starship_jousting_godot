extends PanelContainer

@onready var playerName = $MarginContainer/HBoxContainer/PlayerName
@onready var playerScore = $MarginContainer/HBoxContainer/Score

func setPlayerName(player_name):
	playerName.text = str(player_name)
func setScore(score):
	playerScore.text = str(score)
		
