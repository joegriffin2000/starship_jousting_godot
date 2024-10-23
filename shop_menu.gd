extends CanvasLayer


func _on_quest_button_pressed() -> void:
	$Panel/Quests.visible = true
	$Panel/Upgrades.visible = false
	print("quest pressed")


func _on_upgrade_button_pressed() -> void:
	$Panel/Quests.visible = false
	$Panel/Upgrades.visible = true
	print("upgrade pressed")


func _on_upgrade_pressed() -> void:
	print("upgrade bought")


#func _on_upgrades_gui_input(event: InputEvent) -> void:
	#if event = InputEvent.
