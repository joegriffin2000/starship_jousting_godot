extends Node2D

func _ready():
	ShopMenu.visible = false
	$Ship/Action_Timer.dash.connect($HUD/Dash.dash_start)
	ShopMenu.get_node("Panel/Quests/Quest").quest_received.connect($HUD/QuestDetail.change_text)
	print("main ready")
