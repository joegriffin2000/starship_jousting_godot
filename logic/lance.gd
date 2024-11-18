extends Hitbox

func _ready() -> void:
	set_collision_layer_value(2, false)
	#print(get_collision_layer_value(2))
	
func activate():
	visible = true
	set_collision_layer_value(2, true)
	
func deactivate():
	visible = false
	set_collision_layer_value(2, false)
