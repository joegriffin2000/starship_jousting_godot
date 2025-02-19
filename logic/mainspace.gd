extends Node2D

@export var playerScene: PackedScene

func _ready():
	ShopMenu.visible = false
	
	var index = 0
	for i in GameManager.Players:
		var currentPlayer = playerScene.instantiate()
		add_child(currentPlayer)
		for spawnLocation in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawnLocation.name == str(index):
				currentPlayer.global_position = spawnLocation.global_position
		index += 1
