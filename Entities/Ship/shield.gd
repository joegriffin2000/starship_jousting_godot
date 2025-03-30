extends Hurtbox

@onready var iframe_timer = $Iframe
@onready var sprite = $Sprite2D
@export var in_iframe = false
var my_lance

var shield_texture = [
	load("res://Sprites/shield_level_1.png"),
	load("res://Sprites/shield_level_2.png"),
	load("res://Sprites/shield_level_3.png"),
]

func _process(_delta):
	match int(owner.health):
		2:
			sprite.texture = shield_texture[0]
		3:
			sprite.texture = shield_texture[1]
		4:
			sprite.texture = shield_texture[2]
		_:
			pass

func activate():
	if owner.is_local_authority():
		visible = true
		set_collision_mask_value(2, true)
		owner.health = owner.maxHealth
		owner.shielded = true
		my_lance = owner.get_node("Lance")
	
func deactivate():
	if owner.is_local_authority():
		visible = false
		set_collision_mask_value(2, false)
		owner.shielded = false

func on_area_entered(hitbox: Hitbox):
	if owner.is_local_authority():
		if hitbox != my_lance:
			if not in_iframe:
				owner.take_damage(hitbox.owner)
				iframe_timer.start()
				in_iframe = true
				flicker()
				
			if hitbox.owner.has_method("get_knockback"):
				hitbox.owner.get_knockback()
			
			if owner.health <= 1:
				await iframe_timer.timeout
				deactivate()

func flicker():
	if owner.is_local_authority():
		while in_iframe:
			sprite.modulate = Color(sprite.modulate, randf_range(0, 1))
			await get_tree().create_timer(0.05).timeout
		sprite.modulate = Color(sprite.modulate, 0.75)
	
func _on_iframe_timeout() -> void:
	if owner.is_local_authority():
		in_iframe = false
