extends CanvasLayer

@onready var displayScore = $PanelContainer/MarginContainer/Rows/TotalScoreTxt

func _on_ship_player_died(score: Variant) -> void:
	var newText = str("Total Score: ", score)
	displayScore.set_text(newText)
	visible = true
	print(displayScore.get_text())

func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://mainspace.tscn")
