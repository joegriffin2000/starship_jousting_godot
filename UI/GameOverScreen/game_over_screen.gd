extends CanvasLayer

@onready var displayScore = $PanelContainer/MarginContainer/Rows/TotalScoreTxt
@onready var req = $HTTPRequest
@onready var client_trusted_cas = X509Certificate.new()

@onready var shop_menu = get_tree().root.get_node("Game").get_node("ShopMenu")

func _ready() -> void:
	SignalBus.player_died.connect(_on_ship_player_died)

func _on_ship_player_died(score: Variant) -> void:
	var newText = str("Total Score: ", score)
	displayScore.set_text(newText)
	self.visible = true
	get_node("/root/Game/HUD").visible = false
	
	client_trusted_cas.load("res://fullchain.pem")
	#client_trusted_cas.load("/home/systemduser/starship_jousting/static/js/fullchain.pem")
	var client_tls_options = TLSOptions.client(client_trusted_cas)
	req.set_tls_options(client_tls_options)
	
	var data_to_send = {
		"user": str(ShipData.playerName),
		"score": score
	}
	var json = JSON.stringify(data_to_send)
	var headers = ["Content-Type: application/json"]
	var error = req.request("http://starship_jousting.space/leaderboard_push1", headers, HTTPClient.METHOD_POST, json)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _on_main_menu_btn_pressed() -> void:
	ShipData.reset()
	shop_menu.get_node("Panel/Upgrades/Upgrade").reset()
	NetworkState.disconnect_me()
	get_tree().change_scene_to_file("res://UI/TitleScreen/title_screen.tscn")
