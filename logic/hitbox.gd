extends Area2D
class_name Hitbox

#Add an area2D on the thing you want to do damage (like the lance)
#add a collision shape on it and attach a script to the area2D
#change the first line to:
#extends Hitbox
func _init() -> void:
	collision_layer = 2
	collision_mask = 0
