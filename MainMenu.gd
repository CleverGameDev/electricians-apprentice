extends "res://Metadata.gd"

var can_show: = true

var newgame
var about
var loadgame
var blank_count = 0
var exit
var buddy

func _ready():
	var buddy_scene = preload("res://Buddy.tscn")
	buddy = buddy_scene.instance()
	buddy.get_node("Label").text = "Welcome to the Electrician's Apprentice!\nClick New Game to start."
	add_child(buddy)
	newgame = $Control/VBoxContainer/NewGame
	newgame.connect("pressed", self, "_on_new_game_pressed")
	loadgame = $Control/VBoxContainer/LoadGame
	loadgame.connect("pressed", self, "_on_load_game_pressed")
	about = $Control/VBoxContainer/About
	about.connect("pressed", self, "_on_about_pressed")
	exit = $Control/VBoxContainer/Exit
	exit.connect("pressed", self, "_on_exit_pressed")

func _on_new_game_pressed():
	buddy.free()
	saveLevel(1)
	saveDataToCookies()
	get_tree().change_scene("res://GameScene.tscn")

func _on_load_game_pressed():
	buddy.free()
	get_tree().change_scene("res://GameScene.tscn")

func _on_about_pressed():
	buddy.get_node("Label").text = "code: stoecker\ncode: vzhou\nassets: gashley\nlevels: antonio"

func _on_exit_pressed():
	get_tree().quit()
