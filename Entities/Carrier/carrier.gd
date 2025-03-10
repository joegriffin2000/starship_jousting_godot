extends StaticBody2D

var carrierName = "ALPHA"

func _on_shop_area_entered(body):
	if body.has_method("shop_entered") and body.is_local_authority():
		body.shop_entered()
		if ShipData.quest != null: # If we have a quest:
			var awardQuest = false
			print(ShipData.quest.getTimeLeft())
			# Check if we have a completed quest
			
			# For GOAT quests, progress < total:
			if ShipData.quest.faction == "GOAT":
				if carrierName == ShipData.quest.entityID and (ShipData.quest.progress < ShipData.quest.total):
					awardQuest = true
			# For all other quests, progress == total:
			elif ShipData.quest.progress == ShipData.quest.total:
				awardQuest = true
				
			# Handle completion (giving reward) if we have a completed quest.
			if awardQuest == true:
				ShipData.credits += ShipData.quest.reward
				#ShipData.totalScore += ShipData.quest.reward
				ShipData.totalScore = ShipData.quest.reward
				print("credits:",ShipData.credits)
				SignalBus.credits_updated.emit()
				SignalBus.score_updated.emit()
				
				# Remove quest from ship so that we can take a new one.
				SignalBus.quest_removed.emit()
				ShipData.quest.deactivate()
				ShipData.quest = null
		
		body.get_node("Shield").activate()
		body.get_node("Shield").in_iframe = true
		
		owner.get_node("ShopMenu").visible = true
		print("shop open")
		owner.get_node("ShopMenu").get_node("Panel/Quests/QuestMenu").generateQuests()

func _on_shop_area_exited(body):
	if body.has_method("shop_exited"):
		body.shop_exited()
		body.get_node("Shield").in_iframe = false
		owner.get_node("ShopMenu").visible = false
