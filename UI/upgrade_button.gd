extends Button
class_name UpgradeButton

@onready var max_connect_count = 9
@onready var purchase_menu = $Panel
@onready var purchase_details = $Panel/Details

var connections = {
	"tl":null, "tc":null, "tr":null,
	"ml":null, "mc":null, "mr":null,
	"bl":null, "bc":null, "br":null,
}

var stat = "speed"
var id = 0
var isStatBoost = false
var value = 0.0
var max = 0
var current = 0
var cost = 0 
var parent_id
#enum upgrade_types {STAT, MODS}

func _init():
	pressed.connect(on_button_pressed)
	SignalBus.check_upgrade_locked.connect(unlock)
	
func reset():
	queue_free()
	
func get_connection_count():
	var count=0
	for i in connections:
		if connections[i] != null:
			count+=1
	return count
	
func set_upgrade_stat_increase(id:int, name:StringName, description:StringName, stat_to_increase: StringName, change: float, max_purchase: int, cost: int, img:StringName, isDecrease:bool = false):
	self.stat = stat_to_increase
	self.isStatBoost = true

	self.icon = load("res://Sprites/"+img)
	self.id = id
	self.max = max_purchase
	self.cost = cost
	
	$Panel/Title.text = str(name)
	
	if not isDecrease:
		self.value = change
		$Panel/Description.text = description 
		$Panel/Details.text = "(" + str(current) + "/" + str(max) + ")"
		$Panel/BuyButton.text = str(cost) + "$"
	else:
		self.value = -1 * change
		$Panel/Description.text = description 
		$Panel/Details.text = "(" + str(current) + "/" + str(max) + ")"
		$Panel/BuyButton.text = str(cost) + "$"

func set_upgrade_special(id:int, name:StringName, description:StringName, max_purchase: int, cost: int, img:StringName):
	self.icon = load("res://Sprites/"+img)
	self.id = id
	self.max = max_purchase
	self.cost = cost
	
	$Panel/Title.text = str(name)
	$Panel/Description.text = description 
	$Panel/Details.text = "(" + str(current) + "/" + str(max) + ")"
	$Panel/BuyButton.text = str(cost) + "$"
	
func on_button_pressed():
	purchase_menu.visible = !purchase_menu.visible

func _on_buy_button_pressed() -> void:
	if ShipData.credits >= cost:
		ShipData.credits -= cost
		SignalBus.upgrade_special.emit(id,value)
		
		current += 1
		purchase_details.text = "(" + str(current) + "/" + str(max) + ")"
		if current >= max:
			disabled = true
			purchase_menu.visible = false
			SignalBus.check_upgrade_locked.emit(id)
		
		SignalBus.credits_updated.emit()

func _on_cancel_button_pressed() -> void:
	purchase_menu.visible = false

func unlock(incoming_id):
	if parent_id == incoming_id:
		disabled = false
