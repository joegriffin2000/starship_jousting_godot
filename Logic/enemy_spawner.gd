extends MultiplayerSpawner


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	set_spawn_function(self.spawn_bot)

func spawn_bot(id: int) -> Node:
	print("Spawning bot")
	# Instantiate a new player for this client.
	var bot = preload("res://Entities/Enemy/enemy_ship.tscn").instantiate()
	bot.name = "BOT" + str(id)
	bot.set_multiplayer_authority(1)
	return bot
