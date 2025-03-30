extends Timer

func start_cd(dur):
	if owner.is_local_authority():
		start(dur)
	
func is_in_cd():
	return !is_stopped()
