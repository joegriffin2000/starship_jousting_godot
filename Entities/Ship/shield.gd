extends Hurtbox

@export var durability = 1
@export var max_durability = 1
@onready var iframe_timer = $Iframe
@onready var sprite = $Sprite2D
var in_iframe = false
var my_lance

func activate():
	visible = true
	set_collision_mask_value(2, true)
	durability = max_durability
	owner.shielded = true
	my_lance = owner.get_node("Lance")
	
func deactivate():
	visible = false
	set_collision_mask_value(2, false)
	owner.shielded = false

func on_area_entered(hitbox: Hitbox):
	if hitbox != my_lance:
		if not in_iframe:
			durability -= 1
			iframe_timer.start()
			in_iframe = true
			flicker()
		
		if hitbox.owner.has_method("get_knockback"):
			hitbox.owner.get_knockback()
		if durability <= 0:
			await iframe_timer.timeout
			in_iframe = false
			deactivate()
	
func flicker():
	var flicker
	while in_iframe:
		sprite.modulate = Color(sprite.modulate, randf_range(0, 1))
		await get_tree().create_timer(0.05).timeout
	sprite.modulate = Color(sprite.modulate, 0.44)
	
func _on_iframe_timeout() -> void:
	in_iframe = false
