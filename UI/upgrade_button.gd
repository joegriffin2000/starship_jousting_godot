extends Button
class_name UpgradeButton

@onready var connect_count = 0
@onready var max_connect_count = 4
@onready var purchase_menu = $Panel
@onready var purchase_details = $Panel/Details
var stat = "speed"
var increase = 0
var max = 0
var current = 0
var cost = 0 
#enum upgrade_types {STAT, MODS}

func _init():
	pressed.connect(on_button_pressed)
	
func reset():
	queue_free()
	
func set_upgrade_modification():
	pass
	
func set_upgrade_stat_increase(stat_to_increase: StringName, increase_value: int, max_purchase: int, cost: int):
	if stat_to_increase in ShipData:
		stat = stat_to_increase
	else: 
		return
	increase = increase_value
	max = max_purchase
	self.cost = cost
	$Panel/Description.text = "Increase " + str(stat) + " by " + str(increase)
	$Panel/Details.text = "(" + str(current) + "/" + str(max) + ")"
	$Panel/BuyButton.text = str(cost) + "$"
	
func on_button_pressed():
	purchase_menu.visible = !purchase_menu.visible

func _on_buy_button_pressed() -> void:
	if ShipData.credits >= cost:
		ShipData.credits -= cost
		print("upgrade bought")
		print("old ", stat, " : ", ShipData.get(stat))
		ShipData.set(stat, ShipData.get(stat) + increase)
		print("new ", stat, " : ", ShipData.get(stat))
		current += 1
		purchase_details.text = "(" + str(current) + "/" + str(max) + ")"
		if current >= max:
			disabled = true
			purchase_menu.visible = false
			
		SignalBus.credits_updated.emit()


func _on_cancel_button_pressed() -> void:
	purchase_menu.visible = false
