extends CenterContainer
var value_bt_numpad = 0
var str_bt_nupad = ""
signal numpad_button_pressed_from_button_instance(id_bt_numpad)


func _ready():
	pass # Replace with function body.


func set_text(text):
	$Label.text = text

func set_value_bt_numpad(value):
	value_bt_numpad = value

func _on_texture_numpad_bt_pressed():
	emit_signal("numpad_button_pressed_from_button_instance",value_bt_numpad)
