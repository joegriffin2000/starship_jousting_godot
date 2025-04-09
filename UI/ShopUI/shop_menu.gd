extends CanvasLayer

func _ready() -> void:
	SignalBus.credits_updated.connect(_on_credits_updated)

func set_carrier_label(carrier_name: String) -> void:
	$Panel/CarrierNameLabel.text = str("Carrier ", carrier_name)

func _on_credits_updated() -> void:
	$Panel/CreditsLabel.text = str("$", ShipData.credits)

func _on_quest_button_pressed() -> void:
	$Panel/Quests.visible = true
	$Panel/UpgradeTree.visible = false
	$Panel/UpgradePanel.visible = false

func _on_upgrade_button_pressed() -> void:
	$Panel/Quests.visible = false
	$Panel/UpgradeTree.visible = true
	$Panel/UpgradePanel.visible = true
