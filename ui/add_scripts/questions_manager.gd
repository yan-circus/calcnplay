extends Node
var path = "user://questions_presets.json"

# The default values
var default_questions = {
    "presets":[
        {
		"id":1,
		"name":"Table de multiplication 1-10",
		"type":"calculated_by_computer",
		"comment":"...",
		"operators":"*",
		"max_values":[
		    10,
		    10
		],
		"min_values":[
		    
		],
		"max_result":0,
		"percent_speed-level1":0,
		"percent_speed-level2":10,
		"percent_speed-level3":30,
		"percent_speed-level4":60,
		"percent_speed-level5":100
	}
	]
}

var data_questions = { }
var list_questions = []



# Called when the node enters the scene tree for the first time.
func _ready():
	print("chargement questions_manager")
	load_questions_from_json()
	list_questions = questions_dictionary()
	
	display_questions()

func load_questions_from_json():
	var file = File.new()
	
	if not file.file_exists(path):
		reset_data()
		return
	
	file.open(path, file.READ)
	
	var text = file.get_as_text()
	
	data_questions = parse_json(text)
	#print("type data de data_questions: ", typeof(data_questions))
	#print(data_questions['presets'][0]["name"])
	file.close()

func reset_data():
	# Reset to defaults
	data_questions = default_questions.duplicate(true)

func display_questions():
	print("dictionaire questions")
	print(data_questions)
	print(JSON.print(data_questions))
	
func questions_dictionary():
	list_questions = data_questions['presets']
	return list_questions

func get_preset_by_id(id):
	var curent_preset ={}
	for i in list_questions:
		if int(i["id"]) == id:
			curent_preset = i
	return curent_preset
