extends Timer

#
func _ready() -> void:
	if owner.is_local_authority():
		SignalBus.dash_regen.connect(_on_action_timeout)

func start_dash(dur):
	if owner.is_local_authority():
		start(dur)
		owner.dash = true
		SignalBus.dash.emit(owner.dash_cd)
	
func is_in_action():
	return !is_stopped()
	
func start_knockback(dur):
	if owner.is_local_authority():
		stop()
		owner.dash = false
		start(dur)
		owner.knockback = true

func _on_action_timeout() -> void:
	if owner.is_local_authority():
		stop()
		owner.knockback = false
		owner.dash = false

#func dash_reset():
	#stop()
	#owner.knockback = false
	#owner.dash = false
