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
	print("ICI choose_background")
	current_file = list_files[randi() % len(list_files)]
	print("IMAGE BACKGROUND")
	print(current_file)
	var path_and_file = path +"/" + current_file
	print(path_and_file)
	
	$BgRect.texture = load(path_and_file)

func get_list_files_new():
	var files = []
	var dir = Directory.new()
	
	var format_path = path

	
	dir.open(format_path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			print("fin de la liste de fichiers")
			break
		elif not file.begins_with("."):
			var ext = file.get_extension()
			#print(file, ext)
			#if ext == "jpg":
			files.append(file)
	print(files)
	dir.list_dir_end()
	return files

func get_list_files():
	var nb_photos = 5
	var files = []
	var name_file = ""
	print("voici le path: ", path, "***fin***")
	
	for i in range(45):
		name_file = "bg_image%03d.jpg" % (i+1)
		files.append(name_file)
		#print(name_file)
	return files
	
func get_list_files_org():
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
