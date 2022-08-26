extends VBoxContainer
var id_user = 0
var path_avatar_image = "res://ui/ui_assets/avatars/"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_text(text):
	$Label.text = text

func set_id_user(id):
	id_user = id

func set_image(img):
	var texture_file = path_avatar_image + img
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load(texture_file)
	texture.create_from_image(image)
	$container/Sprite.texture = texture


func start_game():
	var _scene = get_tree().change_scene("res://game/game_dumb.tscn")


func _on_UserButton_pressed():
	GlobalVariables.user_id = id_user
