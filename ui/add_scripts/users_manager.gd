extends Node
var path = "user://users.json"


# Declare member variables here.
var data_users = { }
var list_users = []

var default_questions = {
	"id":1,
	"name":"xxx",
	"image":"fury1.png",
	"color":0,
	"comment":"*"
}


func _ready():
	print("chargement des users")
	load_users_from_json()
	list_users = users_dictionary()
	
	display_users()

func load_users_from_json():
	var file = File.new()
	
	if not file.file_exists(path):
		reset_data()
		return
	
	file.open(path, file.READ)
	
	var text = file.get_as_text()
	
	data_users = parse_json(text)
	file.close()
	
func reset_data():
	# Reset to defaults
	data_users = default_questions.duplicate(true)
	
func users_dictionary():
	list_users = data_users['users']
	return list_users
	
func display_users():
	print("dictionaire des utilisateurs")
	print(data_users)
	print(JSON.print(data_users))


