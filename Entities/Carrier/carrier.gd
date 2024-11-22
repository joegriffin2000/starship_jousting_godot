extends StaticBody2D

func _on_shop_area_entered(body):
	if body.has_method("shop_entered"):
		if ShipData.quest != null: # If we have a quest:
			if ShipData.quest.progress == ShipData.quest.total: # Is quest completed?
				# Handle completion (giving reward) if so.
				ShipData.credits += ShipData.quest.reward
				ShipData.totalScore += ShipData.quest.reward
				print(ShipData.credits)
				SignalBus.credits_updated.emit()
				SignalBus.score_updated.emit()
				# Remove quest from ship so that we can take a new one.
				ShipData.quest = null
				SignalBus.quest_removed.emit()
				
		ShopMenu.visible = true
		print("shop open")
		ShopMenu.get_node("Panel/Quests/QuestMenu").generateQuests()

func _on_shop_area_exited(body):
	if body.has_method("shop_entered"):
		ShopMenu.visible = false
