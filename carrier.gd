extends StaticBody2D



func _on_shop_area_entered(body):
	if body.has_method("shop_entered"):
		$"Shop Menu".visible = true
		print("shop open")
	print("body entered")

func _on_shop_area_exited(body):
	if body.has_method("shop_entered"):
		$"Shop Menu".visible = false
