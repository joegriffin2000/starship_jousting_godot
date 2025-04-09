extends Draggable

var e_button = preload("res://UI/upgrade_button.tscn")

@onready var file = FileAccess.open("res://upgrades.json",FileAccess.READ).get_as_text()
@onready var filecontents = JSON.parse_string(file)

@onready var purchase_menu = get_node("/root/Game/ShopMenu/Panel/UpgradePanel/UpgradeMenu")
@onready var purchase_title = purchase_menu.get_node("MarginContainerTitle/Title")
@onready var purchase_desc = purchase_menu.get_node("Description")
@onready var purchase_details = purchase_menu.get_node("Details")
@onready var purchase_button = purchase_menu.get_node("MarginContainerBuy/BuyButton")

@export var selectedUpgrade: Node

func _ready() -> void:
	super()
	var baseButton = get_node("BaseButton")
	populate(baseButton,0)
	
	for i in baseButton.connections.keys():
		if baseButton.connections[i] != null:
			baseButton.connections[i].disabled = false
	
func populate(parent_button,parent_id):
	for i in filecontents:
		if i["parent_id"] == parent_id:
			var button = e_button.instantiate()
			
			if i["isStatBoost"]:
				button.set_upgrade_stat_increase(int(i["id"]),i["name"],i["description"],i["data"]["stat"], i["data"]["increase_value"], i["max_purchases"], i["cost"], i["img"], i["data"]["isDecrease"])
			else:
				button.set_upgrade_special(int(i["id"]),i["name"], i["description"], i["max_purchases"], i["cost"], i["img"])
			add_button(parent_button, button, i["pos"])
			
			button.parent_id = parent_id
			button.disabled = true
			
			if i["hasChildren"]:
				populate(button,i["id"])

func reset():
	get_tree().call_group("UpgradeButtons", "reset")
	var baseButton = get_node("BaseButton")
	populate(baseButton,0)
		
func add_button(parent_button, button_to_add, pos:String):
	#if parent_button.get_connect_count() >= parent_button.max_connect_count:
		#return
	
	if button_to_add.has_node("Line2D"):
		var line = button_to_add.get_node("Line2D")
		var start_line_offset = Vector2(0,0)
		var end_line_offset = Vector2(75,75)
		var button_offset = Vector2(0,0)
		var button_size = button_to_add.size
		var parent_position = parent_button.position
		#var xtra_space = 30 #this is just the space from button to point of line
		
		#graphical placing of the button and line (relative to parent)
		if pos[1] == "r": #right
			end_line_offset.x = - end_line_offset.x 
			button_offset.x += button_size.x
		elif pos[1] == "l": #left 
			start_line_offset.x += button_size.x 
			button_offset.x -= button_size.x
		else: #center 
			end_line_offset.x = 0 
			start_line_offset.x += button_size.x/2
			
		if pos[0] == "b": #bottom 
			end_line_offset.y = - end_line_offset.y 
			button_offset.y += button_size.y
		elif pos[0] == "t": #top 
			start_line_offset.y += button_size.y 
			button_offset.y -= button_size.y
		else: #middle 
			end_line_offset.y = 0 
			start_line_offset.y += button_size.y/2 
		
		#start point is on the button you're about to add
		#end point is on the parent button
		var starting_point = start_line_offset
		var ending_point = starting_point + end_line_offset
		
		line.add_point(starting_point)
		line.add_point(ending_point)
		
		button_to_add.position = parent_position + button_offset - end_line_offset
		
		button_to_add.add_to_group("UpgradeButtons")
		parent_button.connections[pos] = button_to_add
		# vv this grabs the inverse position and places it in the chosen button's 'connections' dictionary
		button_to_add.connections[
			{
				"tl":"br",
				"tc":"bc",
				"tr":"bl",
				"ml":"mr",
				"mc":"mc",
				"mr":"ml",
				"bl":"tr",
				"bc":"tc",
				"br":"tl",
			}[pos]] = parent_button
		
		add_child(button_to_add)

func _on_buy_button_pressed() -> void:
	if ShipData.credits >= selectedUpgrade.cost:
		ShipData.credits -= selectedUpgrade.cost
		SignalBus.credits_updated.emit()
		SignalBus.upgrade_special.emit(selectedUpgrade.id, selectedUpgrade.value)
		selectedUpgrade.current += 1
		purchase_details.text = "(" + str(selectedUpgrade.current) + "/" + str(selectedUpgrade.max) + ")"
		if selectedUpgrade.current >= selectedUpgrade.max:
			selectedUpgrade.disabled = true
			selectedUpgrade = null
			purchase_title.text = "-"
			purchase_desc.text = "Select an upgrade to view details." 
			purchase_details.text = "(0/0)"
			purchase_button.text = "$0"
			purchase_button.disabled = true
			SignalBus.check_upgrade_locked.emit(id)
