extends Button
class_name UpgradeButton

@onready var max_connect_count = 9
@onready var upgrade_tree = get_node("/root/Game/ShopMenu/Panel/UpgradeTree/Upgrade")
@onready var purchase_menu = get_node("/root/Game/ShopMenu/Panel/UpgradePanel/UpgradeMenu")
@onready var purchase_title = purchase_menu.get_node("MarginContainerTitle/Title")
@onready var purchase_desc = purchase_menu.get_node("Description")
@onready var purchase_details = purchase_menu.get_node("Details")
@onready var purchase_button = purchase_menu.get_node("MarginContainerBuy/BuyButton")

var connections = {
	"tl":null, "tc":null, "tr":null,
	"ml":null, "mc":null, "mr":null,
	"bl":null, "bc":null, "br":null,
}

var stat = "speed"
var id = 0
var isStatBoost = false
var value = 0.0
var current = 0
var max = 0
var cost = 0

var title = ""
var description = ""

#enum upgrade_types {STAT, MODS}

func _init():
	toggled.connect(_on_button_toggled)
	
func reset():
	queue_free()
	
func get_connection_count():
	var count = 0
	for i in connections:
		if connections[i] != null:
			count += 1
	return count
	
func set_upgrade_stat_increase(id:int, title:StringName, description:StringName, stat_to_increase: StringName, change: float, max_purchase: int, cost: int, img:StringName, isDecrease:bool = false):
	self.stat = stat_to_increase
	self.isStatBoost = true
	
	self.title = title
	self.description = description
	self.icon = load("res://Sprites/"+img)
	self.id = id
	self.max = max_purchase
	self.cost = cost
	
	if not isDecrease:
		self.value = change
	else:
		self.value = -1 * change

func set_upgrade_special(id:int, title:StringName, description:StringName, max_purchase: int, cost: int, img:StringName):
	self.title = title
	self.description = description
	self.icon = load("res://Sprites/"+img)
	self.id = id
	self.max = max_purchase
	self.cost = cost
	
func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		upgrade_tree.selectedUpgrade = self
		purchase_title.text = self.title
		purchase_desc.text = self.description 
		purchase_details.text = "(" + str(self.current) + "/" + str(self.max) + ")"
		purchase_button.text = "$" + str(self.cost)
		purchase_button.disabled = false
	elif self.get_button_group().get_pressed_button() == null:
		upgrade_tree.selectedUpgrade = null
		purchase_title.text = "-"
		purchase_desc.text = "Select an upgrade to view details." 
		purchase_details.text = "(0/0)"
		purchase_button.text = "$0"
		purchase_button.disabled = true
	
