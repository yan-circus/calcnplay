extends Control


func _ready():
	$VBoxContainer/content/CheckButtonSound.pressed = GlobalVariables.sound_state
	$VBoxContainer/content/CheckButtonMusic.pressed = GlobalVariables.music_state
	$VBoxContainer/content/CheckButtonNumpad.pressed = GlobalVariables.display_numpad
	
	print("$$$")
	print("sound : " , GlobalVariables.sound_state)
	print("music : " , GlobalVariables.music_state)

func _on_CheckButtonSound_toggled(button_pressed):
	GlobalVariables.sound_state = button_pressed


func _on_CheckButtonMusic_toggled(button_pressed):
	GlobalVariables.music_state = button_pressed

func _on_CheckButtonNumpad_toggled(button_pressed):
	GlobalVariables.display_numpad = button_pressed



func _on_Tbutton_back_pressed():
	var _scene = get_tree().change_scene("res://ui/pages/main.tscn")



