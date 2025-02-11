extends Area2D

var enemy = preload("res://Entities/Enemy/enemy_ship.tscn")
@onready var area = $CollisionShape2D
var rng = RandomNumberGenerator.new()

func _on_timer_timeout() -> void:
	if has_overlapping_bodies():
		pass
	else:
		var new_enemy = enemy.instantiate()
		new_enemy.global_position.x = rng.randi_range(area.global_position.x - area.shape.size.x,area.global_position.x + area.shape.size.x)
		new_enemy.global_position.y = rng.randi_range(area.global_position.y - area.shape.size.y,area.global_position.y + area.shape.size.y)
		new_enemy.rotation = rng.randf_range(-PI, PI)
		get_tree().root.add_child(new_enemy)
		#print("spawned")
