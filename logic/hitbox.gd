extends Area2D
class_name Hitbox

#Add an area2D on the thing you want to do damage (like the lance)
#add a collision shape on it and attach this script to the area2D
func _init() -> void:
	collision_layer = 2
	collision_mask = 0
