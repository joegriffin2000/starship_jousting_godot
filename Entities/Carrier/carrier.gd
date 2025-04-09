extends StaticBody2D

@onready var carrier_name = self.get_name()
@onready var shop_menu = get_node("/root/Game/ShopMenu")

func _on_shop_area_entered(body):
	if body.has_method("shop_entered") and body.is_local_authority():
		body.shop_entered()
		if ShipData.quest != null: # If we have a quest:
			var awardQuest = false
			# Check if we have a completed quest
			
			# For GOAT quests, progress < total:
			if ShipData.quest.faction == "GOAT":
				if carrier_name == ShipData.quest.entityName and (ShipData.quest.progress < ShipData.quest.total):
					awardQuest = true
			# For all other quests, progress == total:
			elif ShipData.quest.progress == ShipData.quest.total:
				awardQuest = true
				
			# Handle completion (giving reward) if we have a completed quest.
			if awardQuest == true:
				ShipData.credits += ShipData.quest.reward
				#ShipData.totalScore += ShipData.quest.reward
				ShipData.totalScore += ShipData.quest.reward
				SignalBus.credits_updated.emit()
				SignalBus.score_updated.emit()
				
				# Remove quest from ship so that we can take a new one.
				SignalBus.quest_removed.emit()
				ShipData.quest.deactivate()
				ShipData.quest = null
		
		body.get_node("Shield").activate()
		body.get_node("Shield").in_iframe = true
		
		shop_menu.visible = true
		shop_menu.set_carrier_label(carrier_name)
		shop_menu.get_node("Panel/Quests/QuestMenu").generateQuests(carrier_name)
		get_node("/root/Game/HUD").visible = false

func _on_shop_area_exited(body):
	if body.has_method("shop_exited") and body.is_local_authority():
		body.shop_exited()
		shop_menu.get_node("Panel/Quests/QuestMenu").removeQuests()
		shop_menu.get_node("Panel/Quests/QuestMenu").resetQuestMenu()
		body.get_node("Shield").in_iframe = false
		shop_menu.visible = false
		get_node("/root/Game/HUD").visible = true
