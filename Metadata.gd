extends Node2D

# TODO: create a GetClever app for this and fill out this constant
var appId = ""
var currentUserId = ""
var scores = null

func _ready():
	var userId = getUserId()
	currentUserId = userId
	
func getUserId():
	var userId = ""
	for argument in OS.get_cmdline_args():
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			if key_value[0] == "--user-id":
				userId = key_value[1]
	return userId

func saveScore(level, score):
	if currentUserId == "":
		push_error("unable to save score: no user")
		return

	var request = HTTPRequest.new()
	request.connect("request_completed", self, "_saveScoreComplete")
	
	var url = "https://app.getclever.com/api/userAppMetadatas/{userId}/recordScore/{appId}" % [currentUserId, appId]
	var body = {"level": level, "score": score}
	var error = request.request(url, [], true, HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("unable to save score: http request error")
		
func _saveScoreComplete(result, response_code, headers, body):
	print_debug("finished saving score")

func getScores(level):
	if currentUserId == "":
		push_error("unable to save score: no user")
		return

	var request = HTTPRequest.new()
	request.connect("request_completed", self, "_getScoresComplete")
	
	var url = "https://app.getclever.com/api/userAppMetadatas"
	# TODO: get session here
	var error = request.request(url)
	if error != OK:
		push_error("unable to get scores: http request error")

func _getScoresComplete(result, response_code, headers, body):
	if result != 0:
		push_error("unable to get scores: http response error")
		return
		
	if response_code != 200:
		push_error("unable to get scores: %d error code " % response_code)
		return
		
	var parsedBody = parse_json(body.get_string_from_utf8())
	for metadata in parsedBody:
		if metadata["appID"] == appId:
			scores = metadata["scores"]
	
	return
