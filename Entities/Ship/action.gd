extends Timer

#
func _ready() -> void:
	#print("action ready")
	#dash.connect(Callable(Hud.get_node("Dash"),"dash_start"))
	SignalBus.dash_regen.connect(_on_action_timeout)
	pass

func start_dash(dur):
	#wait_time = dur
	start(dur)
	owner.dash = true
	SignalBus.dash.emit(owner.dash_cd)
	
func is_in_action():
	return !is_stopped()
	
func start_knockback(dur):
	stop()
	owner.dash = false
	start(dur)
	owner.knockback = true

func _on_action_timeout() -> void:
	stop()
	owner.knockback = false
	owner.dash = false
	#
#func dash_reset():
	#stop()
	#owner.knockback = false
	#owner.dash = false
