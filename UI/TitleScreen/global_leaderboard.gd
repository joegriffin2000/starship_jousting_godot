extends VBoxContainer

@onready var globalLbEntry = preload("res://UI/TitleScreen/global_lb_entry.tscn")
@onready var lbContainer = $MarginContainer2/ScrollContainer/LeaderboardContainer
@onready var req = $HTTPRequest
@onready var loading = $MarginContainer2/Loading

#@onready var dbString = FileAccess.open("res://db_config.txt",FileAccess.READ).get_as_text()
#@onready var json = JSON.new()
#@onready var filecontents = json.parse_string(file)
#@onready var lbData = filecontents["leaderboard"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Loading data spinner
	loading.visible = true
	
	# Create an HTTP request node and connect its completion signal.
	req.request_completed.connect(_http_request_completed)
	var client_trusted_cas = load("res://nginx_selfsigned.crt")
	var client_tls_options = TLSOptions.client_unsafe(client_trusted_cas)
	req.set_tls_options(client_tls_options)
	
	# GET Request for leaderboard data
	var error = req.request("http://137.184.49.244/leaderboard_pull20")
	if error != OK:
		push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	
	#print(result)
	#print(response_code)
	
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		if json != null:
			loading.visible = false
			#print(json)
			make_leaderboard(json)

func make_leaderboard(lbData):
	for item in lbData:
		var entry = globalLbEntry.instantiate()
		lbContainer.add_child(entry)
		entry.setPlayerName(item["user"])
		entry.setScore(item["score"])
