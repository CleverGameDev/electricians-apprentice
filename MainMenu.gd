extends Node2D

var can_show: = true

var newgame
var about
var blank
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
	blank = $Control/VBoxContainer/Blank
	blank.connect("pressed", self, "_on_blank_pressed")
	about = $Control/VBoxContainer/About
	about.connect("pressed", self, "_on_about_pressed")
	exit = $Control/VBoxContainer/Exit
	exit.connect("pressed", self, "_on_exit_pressed")

func _on_new_game_pressed():
	buddy.free()
	get_tree().change_scene("res://GameScene.tscn")

func _on_blank_pressed():
	blank_count += 1
	if blank_count == 1:
		buddy.get_node("Label").text = "This button doesn't really do anything. You have pressed this button 1 time."
	else:
		buddy.get_node("Label").text = "This button doesn't really do anything. You have pressed this button " + str(blank_count) + " times."

func _on_about_pressed():
	buddy.get_node("Label").text = "code: stoecker\ncode: vzhou\nassets: gashley\nlevels: antonio"

func _on_exit_pressed():
	get_tree().quit()
