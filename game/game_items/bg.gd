extends Node2D
var list_files = []
var current_file = ""
var path = ""

func _ready():
	pass

func init(p):
	path = p
	list_files = get_list_files()
	#print(list_files)
	list_files.shuffle()
	#current_file

func choose_background():
	current_file = list_files[randi() % len(list_files)]
	print("IMAGE BACKGROUND")
	print(current_file)
	var path_and_file = path +"/" + current_file
	print(path_and_file)
	
	$BgRect.texture = load(path_and_file)

func get_list_files():
	var files = []
	var dir = Directory.new()
	print("voici le path: ", path, "***fin***")
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			print("fin de la liste de fichiers")
			break
		elif not file.begins_with("."):
			var ext = file.get_extension()
			#print(file, ext)
			if ext == "jpg":
				files.append(file)
			
	dir.list_dir_end()
	return files
