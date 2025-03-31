extends PanelContainer

func _ready() -> void:
	await SignalBus.player_finished_setup
	self.visible = false
