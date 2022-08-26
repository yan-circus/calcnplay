extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var ch_info = "Game id :" + str(GlobalVariables.game_id) + " Level : " + str(GlobalVariables.level)
	$Label_Game_Info.text = ch_info


func _input(event):
	var user_key = ""
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://ui/pages/main.tscn")


