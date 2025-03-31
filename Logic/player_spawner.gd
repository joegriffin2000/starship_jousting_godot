extends MultiplayerSpawner


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_spawn_function(self.spawn_player)

func spawn_player(id: int) -> Node:
	# Instantiate a new player for this client.
	var player = preload("res://Entities/Ship/ship.tscn").instantiate()
	# Set the name, so players can figure out their local authority
	player.name = str(id)
	return player
