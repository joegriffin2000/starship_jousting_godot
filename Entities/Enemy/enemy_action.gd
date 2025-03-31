extends Timer

func start_dash(dur):
	if owner.is_local_authority():
		start(dur)
		owner.dashing = true
	
func is_in_action():
	return !is_stopped()
	
func start_knockback(dur):
	if owner.is_local_authority():
		stop()
		owner.dashing = false
		owner.get_node("Lance").deactivate()
		start(dur)
		owner.knockback = true

func _on_action_timeout() -> void:
	if owner.is_local_authority():
		stop()
		owner.knockback = false
		owner.get_node("Lance").deactivate()
		owner.dashing = false
