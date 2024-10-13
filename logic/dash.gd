extends Timer

@onready var timer = $dashtimer
@export var knockback = false

func start_dash(dur):
	#wait_time = dur
	start(dur)
	
func is_in_action():
	return !is_stopped()
	
func start_knockback(dur):
	stop()
	start(dur)
	knockback = true

func _on_timeout() -> void:
	stop()
	knockback = false
