extends CanvasLayer
signal button_numpad_pressed
var key_bt=""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_button_key0_pressed():
	key_bt = "0"
	one_numpad_button_pressed()

func _on_button_key1_pressed():
	key_bt = "1"
	one_numpad_button_pressed()

func _on_button_key2_pressed():
	key_bt = "2"
	one_numpad_button_pressed()

func _on_button_key3_pressed():
	key_bt = "3"
	one_numpad_button_pressed()

func _on_button_key4_pressed():
	key_bt = "4"
	one_numpad_button_pressed()

func _on_button_key5_pressed():
	key_bt = "5"
	one_numpad_button_pressed()

func _on_button_key6_pressed():
	key_bt = "6"
	one_numpad_button_pressed()

func _on_button_key7_pressed():
	key_bt = "7"
	one_numpad_button_pressed()

func _on_button_key8_pressed():
	key_bt = "8"
	one_numpad_button_pressed()

func _on_button_key9_pressed():
	key_bt = "9"
	one_numpad_button_pressed()

func one_numpad_button_pressed():
	emit_signal("button_numpad_pressed")

func show_numpad():
	$Vbox_numpad.visible = true
	
func hide_numpad():
	$Vbox_numpad.visible = false
	
