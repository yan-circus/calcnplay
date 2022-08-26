extends Control
signal level_button
var id_preset = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func set_text(text):
	$Label.text = text
	
func set_id_preset(id):
	id_preset = id

func hide_level_button(level_num):
	if level_num > 5 or  level_num <1:
		print("numéro du niveau hors plage")
	else:
		var st_level = "Button_Level"+str(level_num)
		print(.get_node(st_level).get_path())
		
		.get_node(st_level).visible=false


func _on_Button_Level1_pressed():
	GlobalVariables.level = 1
	go_to_main_launch_game()

func _on_Button_Level2_pressed():
	GlobalVariables.level = 2
	go_to_main_launch_game()

func _on_Button_Level3_pressed():
	GlobalVariables.level = 3
	go_to_main_launch_game()

func _on_Button_Level4_pressed():
	GlobalVariables.level = 4
	go_to_main_launch_game()

func _on_Button_Level5_pressed():
	GlobalVariables.level = 5
	go_to_main_launch_game()

func go_to_main_launch_game():
	print(GlobalVariables.level)
	get_node("/root/Main").launch_game(id_preset)
	
