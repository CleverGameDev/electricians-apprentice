extends Node2D

var can_show: = true

var newgame

func _ready():
	newgame = $Control/VBoxContainer/NewGame
	newgame.connect("pressed", self, "_on_new_game_pressed")

func _on_new_game_pressed():
	get_tree().change_scene("res://GameScene.tscn")
