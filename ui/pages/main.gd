extends Control
var game = preload("res://ui/pages/options.tscn")
var line_preset_scn = preload("res://ui/ui_items/game_entry.tscn")



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("***")
	print("sound : " , GlobalVariables.sound_state)
	print("music : " , GlobalVariables.music_state)
	load_questions()


func load_questions():
	for i in QuestionsManager.list_questions:
		add_line_preset(i)
	
func add_line_preset(dict_line):
	#ajoute une ligne de preset 
	var line_preset = line_preset_scn.instance()
	$VBoxContainer/MarginContainer/ScrollContainer/content.add_child(line_preset)
	line_preset.set_text(dict_line["name"])
	line_preset.set_id_preset(int(dict_line["id"]))
	
	#verification des niveaux affichables
	for cpt in range(1,5+1):	#de 1 à 5
		var st_level = "percent_speed-level"+str(cpt)
		if st_level in dict_line:
			print(dict_line["name"],"level",cpt,"existant")
		else:
			print(dict_line["name"],"level",cpt,"inexistant")
			line_preset.hide_level_button(cpt)


func _on_ButtonOptions_pressed():
	print("Bouton options...")
	var _scene = get_tree().change_scene("res://ui/pages/options.tscn")


func _on_ButtonScores_pressed():
	print("Bouton scores...")
	var _scene = get_tree().change_scene("res://ui/pages/scores.tscn")



func _on_ButtonTest1_pressed():
	QuestionsManager.questions_dictionary()


func _on_ButtonPlay_pressed():
	launch_game(0)


func _on_Tbutton_bexit_pressed():
	get_tree().quit()

func _on_ButtonTest2_pressed():
	print("add preset")
	var line_preset = line_preset_scn.instance()
	$VBoxContainer/ScrollContainer/content.add_child(line_preset)
	
func launch_game(id_preset):
	print("on lance une partie...")
	print("id:",str(id_preset))
	
	GlobalVariables.current_preset = QuestionsManager.get_preset_by_id(id_preset)
	print(GlobalVariables.current_preset)
	var _scene = get_tree().change_scene("res://ui/pages/pre_game.tscn")
