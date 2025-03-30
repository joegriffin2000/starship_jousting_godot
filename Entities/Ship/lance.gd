extends Hitbox

func _ready() -> void:
	if owner.is_local_authority():
		set_collision_layer_value(2, false)
	
func activate():
	if owner.is_local_authority():
		visible = true
		set_collision_layer_value(2, true)
	
func deactivate():
	if owner.is_local_authority():
		visible = false
		set_collision_layer_value(2, false)
