extends Timer

func start_cd(dur):
	#wait_time = dur
	start(dur)
	
func is_in_cd():
	return !is_stopped()
