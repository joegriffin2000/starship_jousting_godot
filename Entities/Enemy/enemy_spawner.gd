extends Area2D

var enemy = preload("res://Entities/Enemy/enemy_ship.tscn")
@onready var area = $CollisionShape2D
var rng = RandomNumberGenerator.new()
var spawnCounter = 1

func _on_timer_timeout() -> void:
	if NetworkState.is_server:
		if has_overlapping_bodies():
			pass
		else:
			var new_enemy = enemy.instantiate()
			
			new_enemy.global_position.x = rng.randi_range(area.global_position.x - area.shape.size.x,area.global_position.x + area.shape.size.x)
			new_enemy.global_position.y = rng.randi_range(area.global_position.y - area.shape.size.y,area.global_position.y + area.shape.size.y)
			new_enemy.rotation = rng.randf_range(-PI, PI)
			
			new_enemy.name = "BOT" + str(spawnCounter)
			new_enemy.set_multiplayer_authority(1)
			
			owner.get_node("Bots").add_child(new_enemy)
			
			new_enemy.set_enemy_name("BOT " + str(spawnCounter))
			spawnCounter += 1
			
			#new_enemy.add_to_group("Enemies")
			#print("spawned")
