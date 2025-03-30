extends VBoxContainer

@onready var globalLbEntry = preload("res://UI/TitleScreen/global_lb_entry.tscn")
@onready var lbContainer = $MarginContainer2/ScrollContainer/LeaderboardContainer
@onready var req = $HTTPRequest
@onready var loading = $MarginContainer2/Loading

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Loading data spinner
	loading.visible = true
	
	# Create an HTTP request node and connect its completion signal.
	req.request_completed.connect(_http_request_completed)
	var client_trusted_cas = X509Certificate.new()
	client_trusted_cas.load("/home/systemduser/starship_jousting/static/js/fullchain.pem")
	var client_tls_options = TLSOptions.client(client_trusted_cas)
	req.set_tls_options(client_tls_options)
	
	# GET Request for leaderboard data
	var error = req.request("https://starship_jousting.space/leaderboard_pull20")
	if error != OK:
		push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
func _http_request_completed(_result, response_code, _headers, body):
	
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		if json != null:
			loading.visible = false
			make_leaderboard(json)

func make_leaderboard(lbData):
	for item in lbData:
		var entry = globalLbEntry.instantiate()
		lbContainer.add_child(entry)
		entry.setPlayerName(item["user"])
		entry.setScore(item["score"])
