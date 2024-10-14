extends Timer

@export var knockback = false
@export var dash = false

func start_dash(dur):
	#wait_time = dur
	start(dur)
	dash = true
	
func is_in_action():
	return !is_stopped()
	
func start_knockback(dur):
	stop()
	start(dur)
	knockback = true

func _on_action_timeout() -> void:
	stop()
	knockback = false
	dash = false
