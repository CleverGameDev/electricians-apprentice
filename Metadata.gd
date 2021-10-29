extends Node2D

var currentUserId = ""
var data = {}

func _ready():
	var userId = getUserId()
	currentUserId = userId
	print("currentUserId: %s" % currentUserId)
	
	data = getDataFromCookies()
	print("data: %s" % data)
	
func getUserId():
	var userId = ""
	for argument in OS.get_cmdline_args():
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			if key_value[0] == "--user-id":
				userId = key_value[1]
	return userId

func saveDataToCookies():
	var save_game = File.new()
	save_game.open("user://%s" % currentUserId, File.WRITE)
	save_game.store_line(to_json(data))
	save_game.close()

func getDataFromCookies():
	var save_game = File.new()
	if not save_game.file_exists("user://%s" % currentUserId):
		return {}
	
	save_game.open("user://%s" % currentUserId, File.READ)
	var result = parse_json(save_game.get_line())
	save_game.close()
	
	return result

func saveLevel(value):
	data["current_level"] = value
	print("saved value %s to key %s" % [value, "current_level"])
	
func getLevel():
	print("got value %s for key %s" % [data.get("current_level", 1), "current_level"])
	# default to level 1
	return data.get("current_level", 1)
