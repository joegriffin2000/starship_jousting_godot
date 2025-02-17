extends Node2D

@export var PlayerScene : PackedScene

func _ready():
	ShopMenu.visible = false
	sendPlayerInformation.rpc_id(1,ShipData.playerName,multiplayer.get_unique_id())
	
	var index = 0
	for i in GameManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				currentPlayer.global_position == spawn.global_position
		index += 1
		
	#print("main ready")
 
@rpc("any_peer","call_local")
func sendPlayerInformation(name,id,score=0):
	print("sendPlayerInformation called, id:"+str(id))
	if GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name":name,
			"id":id,
			"score":score
		}
	if multiplayer.is_server():
		for i in GameManager.Players:
			sendPlayerInformation.rpc(GameManager.Players[i].name,i,GameManager.Players[i].score)
