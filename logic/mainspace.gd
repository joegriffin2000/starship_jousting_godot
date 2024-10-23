extends Node2D

func _ready():
	ShopMenu.visible = false
	$Ship/Action_Timer.dash.connect($HUD/Dash.dash_start)
	print("main ready")
