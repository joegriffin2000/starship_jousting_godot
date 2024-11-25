extends Area2D
class_name Hurtbox

var isEnabled = true
#Add an area2D as a child on the thing you want to take damage (like the ship)
#Add a collision shape on it and attach this script to the area2D
#Note: the hit and hurt boxes works when the hitbox moves into the hurtbox
func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	area_entered.connect(on_area_entered)
	
func on_area_entered(hitbox: Hitbox):
	if isEnabled: 
		if hitbox == null:
			return
		if owner.has_method("take_damage"):
			owner.take_damage(hitbox.owner)
	else:
		print("hitbox disabled")
