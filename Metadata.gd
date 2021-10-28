extends Node2D

var currentUserId = ""
var scores = {}

func _ready():
	var userId = getUserId()
	currentUserId = userId
	print("currentUserId: %s" % currentUserId)
	
	scores = getScoresFromCookies(currentUserId)
	print("scores: %s" % scores)
	
func getUserId():
	var userId = ""
	for argument in OS.get_cmdline_args():
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			if key_value[0] == "--user-id":
				userId = key_value[1]
	return userId

func saveScoresToCookies(userId):
	var save_game = File.new()
	save_game.open("user://%s" % userId, File.WRITE)
	save_game.store_line(to_json(scores))
	save_game.close()

func getScoresFromCookies(userId):
	var save_game = File.new()
	if not save_game.file_exists("user://%s" % userId):
		return
	
	save_game.open("user://%s" % userId, File.READ)
	var result = parse_json(save_game.get_line())
	save_game.close()
	
	return result

func saveScore(level, score):
	scores[level] = score
	print("saved score %s to level %s" % [score, level])
	
func getScore(level):
	print("got score %s for level %s" % [scores[level], level])
	return scores[level]
