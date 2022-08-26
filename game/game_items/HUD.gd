extends CanvasLayer

signal start_game


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_score(score):
	$ScoreLabel.text = str(score)
	
func update_lives(lives):
	$LivesLabel.text = "Vies : " + str(lives)

func update_user_answer(user_answer):
	$UserAnswerLabel.text = str(user_answer)

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$Message.text = "Bravo!"
	$Message.show()
	yield(get_tree().create_timer(1), "timeout")
	$ButtonStart.show()
	$ButtonQuit.show()
	

func _on_ButtonStart_pressed():
	$ButtonStart.hide()
	$ButtonQuit.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()


func _on_ButtonQuit_pressed():
	var _scene = get_tree().change_scene("res://ui/pages/pre_game.tscn")
