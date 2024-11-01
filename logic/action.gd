extends Timer

#
func _ready() -> void:
	print("action ready")
	#dash.connect(Callable(Hud.get_node("Dash"),"dash_start"))

func start_dash(dur):
	#wait_time = dur
	start(dur)
	ShipData.dash = true
	SignalBus.dash.emit(ShipData.dash_cd)
	
func is_in_action():
	return !is_stopped()
	
func start_knockback(dur):
	stop()
	ShipData.dash = false
	start(dur)
	ShipData.knockback = true

func _on_action_timeout() -> void:
	stop()
	ShipData.knockback = false
	ShipData.dash = false
