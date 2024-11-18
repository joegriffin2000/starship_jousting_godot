extends Timer

#
func _ready() -> void:
	#print("action ready")
	#dash.connect(Callable(Hud.get_node("Dash"),"dash_start"))
	pass

func start_dash(dur):
	#wait_time = dur
	start(dur)
	owner.dashing = true
	#SignalBus.dash.emit(ShipData.dash_cd)
	
func is_in_action():
	return !is_stopped()
	
func start_knockback(dur):
	stop()
	owner.dashing = false
	owner.get_node("Lance").deactivate()
	start(dur)
	owner.knockback = true

func _on_action_timeout() -> void:
	stop()
	owner.knockback = false
	owner.get_node("Lance").deactivate()
	owner.dashing = false
