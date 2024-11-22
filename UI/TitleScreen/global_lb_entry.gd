extends PanelContainer

@onready var playerName = $MarginContainer/HBoxContainer/PlayerName
@onready var playerScore = $MarginContainer/HBoxContainer/Score

func setPlayerName(name):
	playerName.text = str(name)
func setScore(score):
	playerScore.text = str(score)
		
