extends CanvasLayer
var numpad_button_tscn = preload("res://game/game_items/numpad_button.tscn")

signal numpad_button_pressed(key)

var key_bt=""
var lst_key = [{'text': '1', 'value': 1}, {'text': '2', 'value': 2}, {'text': '3', 'value': 3}, {'text': '4', 'value': 4}, {'text': '5', 'value': 5},
{'text': '6', 'value': 6}, {'text': '7', 'value': 7}, {'text': '8', 'value': 8}, {'text': '9', 'value': 9}, {'text': '0', 'value': 0}]


# Called when the node enters the scene tree for the first time.
func _ready():
	
	init()


func init():
	for k in lst_key:
		add_button_key(k)
		
func add_button_key(key):
	#ajoute un button au clavier utilisateur
	var keyboard_user_key = numpad_button_tscn.instance()
	$Vbox_numpad/HBoxContainer.add_child(keyboard_user_key)
	keyboard_user_key.set_text(key["text"])
	keyboard_user_key.set_value_bt_numpad(key["value"])
	keyboard_user_key.size_flags_horizontal =  3 #SIZE_FILL + SIZE_EXPAND
	keyboard_user_key.connect("numpad_button_pressed_from_button_instance",self,"one_numpad_button_pressed")


func one_numpad_button_pressed(value_bt):
	print("touche : ", value_bt)
	emit_signal("numpad_button_pressed",value_bt)

func show_numpad():
	$Vbox_numpad.visible = true
	
func hide_numpad():
	$Vbox_numpad.visible = false
	
