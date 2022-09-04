extends Node2D
var list_files = []
var current_file = ""
var path





# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

func init(p):
	path = p
	list_files = list_files_in_directory(path)
	print(list_files)
	list_files.shuffle()
	#current_file

func choose_background():
	current_file = list_files[randi() % len(list_files)]
	print(current_file)
	var path_and_file = path +"/" + current_file
	print(path_and_file)
	var image = Image.new()
	image.load(path_and_file)
	var itex = ImageTexture.new()
	itex.create_from_image(image)

	$BgRect.texture = itex
	
	
	#$BgRect.texture = load(image_texture)

func list_files_in_directory(path):
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
	
	print("liste fichiers: ", files , "***fin")
	return files
