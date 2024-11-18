extends Node2D

#all this script does right now is 
# • navigate to the mainspace on button press 
# • allow the user to put in a userName

@export var playerName: String

var rng = RandomNumberGenerator.new()

func _on_play_button_pressed() -> void:
	if !playerName.is_empty():
		ShipData.playerName = playerName
	else:
		ShipData.playerName = "player_"+ str(rng.randi_range(0,1000))
	get_tree().change_scene_to_file("res://mainspace.tscn")

func _on_line_edit_text_changed(new_text: String) -> void:
	playerName = new_text
