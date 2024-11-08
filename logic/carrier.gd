extends StaticBody2D

func _on_shop_area_entered(body):
	if body.has_method("shop_entered"):
		ShopMenu.visible = true
		print("shop open")
		ShopMenu.get_node("Panel/Quests/Quest").generateQuests()

func _on_shop_area_exited(body):
	if body.has_method("shop_entered"):
		ShopMenu.visible = false
