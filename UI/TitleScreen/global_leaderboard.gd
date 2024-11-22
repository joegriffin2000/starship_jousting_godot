extends VBoxContainer

@onready var globalLbEntry = preload("res://UI/TitleScreen/global_lb_entry.tscn")
@onready var lbCont = $MarginContainer2/ScrollContainer/LeaderboardContainer

@onready var file = FileAccess.open("res://fake_lb.json",FileAccess.READ).get_as_text()
@onready var json = JSON.new()
@onready var filecontents = json.parse_string(file)
@onready var lbData = filecontents["leaderboard"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	make_leaderboard(lbData)
	
	# Create an HTTP request node and connect its completion signal.
	#var http_request = HTTPRequest.new()
	#add_child(http_request)
	#http_request.request_completed.connect(self._http_request_completed)

	# Perform a GET request.
	# TODO: Replace w/ DB endpoint
	#var error = http_request.request("https://httpbin.org/get")
	#if error != OK:
		#push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	make_leaderboard(json)

func make_leaderboard(json):
	# TODO: For loop to initialize a node w/ the leaderboard for every entry in response
	for item in json:
		var entry = globalLbEntry.instantiate()
		lbCont.add_child(entry)
		entry.setPlayerName(item["playerName"])
		entry.setScore(item["playerScore"])
