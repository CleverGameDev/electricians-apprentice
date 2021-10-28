extends Node2D

var can_show: = true

var newgame
var exit
var buddy

func _ready():
	var buddy_scene = preload("res://Buddy.tscn")
	buddy = buddy_scene.instance()
	buddy.get_node("Label").text = "Welcome to the Electrician's Apprentice!\nClick New Game to start."
	add_child(buddy)
	newgame = $Control/VBoxContainer/NewGame
	newgame.connect("pressed", self, "_on_new_game_pressed")
	exit = $Control/VBoxContainer/Exit
	exit.connect("pressed", self, "_on_exit_pressed")

func _on_new_game_pressed():
	buddy.free()
	get_tree().change_scene("res://GameScene.tscn")

func _on_exit_pressed():
	get_tree().quit()
