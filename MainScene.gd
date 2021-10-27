extends Node2D

func _ready():
	get_tree().change_scene("res://MainMenu.tscn")

func exit():
	get_tree().quit()
