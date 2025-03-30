extends PanelContainer

@onready var nameLabel = $MarginContainer/HBoxContainer/PlayerName
@onready var scoreLabel = $MarginContainer/HBoxContainer/Score

@rpc("any_peer", "call_local")
func set_lb_item(pName, pScore):
	nameLabel.text = str(pName)
	scoreLabel.text = str(pScore)
	self.visible = true

@rpc("any_peer", "call_local")
func hide_item():
	self.visible = false
