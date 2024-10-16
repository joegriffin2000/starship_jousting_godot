extends Node2D

func _ready():
	$Ship/Action_Timer.dash.connect($HUD/Dash.dash_start)
	print("main ready")
