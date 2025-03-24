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
#enum upgrade_types {STAT, MODS}

func _init():
	pressed.connect(on_button_pressed)
	
func reset():
	queue_free()
	
func get_connection_count():
	var count=0
	for i in connections:
		if connections[i] != null:
			count+=1
	return count
	
func set_upgrade_stat_increase(id:int, name:StringName, description:StringName, stat_to_increase: StringName, change: float, max_purchase: int, cost: int, img:StringName, isDecrease:bool = false):
	if stat_to_increase in ShipData:
		self.stat = stat_to_increase
		self.isStatBoost = true
	else: 
		return
	
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
		print("upgrade_special")
		#if isStatBoost:
			##print("old ", stat, " : ", ShipData.get(stat))
			##ShipData.set(stat, ShipData.get(stat) + value)
			#SignalBus.upgrade_special.emit(id,value)
			##print("new ", stat, " : ", ShipData.get(stat))
		#else:
			#SignalBus.upgrade_special.emit(id)
			#print("upgrade_special")
		
		current += 1
		purchase_details.text = "(" + str(current) + "/" + str(max) + ")"
		if current >= max:
			disabled = true
			purchase_menu.visible = false
				
		print("upgrade bought")
		SignalBus.credits_updated.emit()

func _on_cancel_button_pressed() -> void:
	purchase_menu.visible = false
