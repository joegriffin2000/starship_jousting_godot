extends Button
class_name UpgradeButton

@onready var connect_count = 0
@onready var max_connect_count = 4
enum upgrade_types {STAT, MODS}

func _init():
	pressed.connect(on_button_pressed)
	pass
	
func on_button_pressed():
	print("upgrade bought")
	pass
