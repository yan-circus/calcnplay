extends Control
var user_entry_tscn = preload("res://ui/ui_items/user_entry.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	load_users()

func load_users():
	for i in UsersManager.list_users:
		add_user(i)

func add_user(dict_user):
	print(dict_user)
	#ajoute un objet utilisateur sur l'interface
	var user = user_entry_tscn.instance()
	$VBoxContainer/MarginContainer/GridContainer.add_child(user)
	user.set_text(dict_user["name"])
	user.set_id_user(int(dict_user["id"]))
	user.set_image(dict_user["image"])

func _on_ButtonPlay_pressed():
	var _scene = get_tree().change_scene("res://game/game.tscn")


func _on_Tbutton_back_pressed():
	var _scene = get_tree().change_scene("res://ui/pages/main.tscn")

func select_id_button():
	#selectionne le button utilateur correspondant à GlobalVariables.user_id
	if GlobalVariables.user_id >0:
		#trouve le bouton dont l'utilisateur poddède cet id 
		pass
		
