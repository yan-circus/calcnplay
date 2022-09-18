extends Node2D
#export (PackedScene) var Quest
var questions_scn = preload("res://game/game_items/quest.tscn")

var score

var nb_lives_init = 3
var nb_lives 
#var question_speed_init = 200			#10 > 66 sec pour tomber
var question_speed = 0				#cf calculate_question_speed()
var question_speed_init = 0			#cf calculate_question_speed()

#var questTimer_wait_time_init = 3
#var questTimer_wait_time_init = (1/question_speed)* 550		
var display_answer_timer_wait_time_init = 1
var current_QuestTimer_wait_time = 0

var nb_question = 0
var step_difficultie = 0
var nb_question_for_a_step = 20

#$Area2D/Ground.position 
 #print("position ground : ", collision_ground_pos) 
var screen_size
var current_body		#pointe vers le dernier body qui a été en collision
var pre_current_body	#pointe vers le body qui était précédemment le current_body.
var is_question_active = false


var current_question = ""
var current_expected_answer = ""
var current_user_answer = ""

var is_playing = false
var is_waiting_answer = false
var cpt_key =0
var list_user_keys = []


func _ready():
	calculate_question_speed()
	if GlobalVariables.display_numpad:
		$Numpad.show_numpad()
	else:
		$Numpad.hide_numpad()
	
	$Bg.init("res://game/game_assets/backgrounds/")
	$Puzzle.create_the_puzzle()
	print("#################################")
	screen_size = get_viewport_rect().size
	print(screen_size.x)
	randomize()
	new_game()

func new_game():
	print("new game")
	is_playing = true
	$Bg.choose_background()
	$Puzzle.display_all_parts()
	score = 0
	nb_lives = nb_lives_init
	question_speed = question_speed_init
	$QuestTimer.wait_time = evaluate_quest_timer()
	#$QuestTimer.wait_time = 5
	$DisplayAnswerTimer.wait_time = display_answer_timer_wait_time_init
	
	display_user_answer()
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.update_lives(nb_lives)
	$HUD.show_message("Get Ready")
	
func _on_StartTimer_timeout():
	pick_a_question()
	$QuestTimer.start()
	print("début de la partie")
	
func calculate_question_speed():
	var key = "percent_speed-level" + str(GlobalVariables.level)
	var preset_speed = GlobalVariables.current_preset[key]
	var ratio = 200
	question_speed_init = int((preset_speed+1)/100 * ratio)
	print("#################################")
	print("*******question_speed*************",question_speed_init) 
	print("#################################")
	
func _input(event):
	var user_key = ""
	if event.is_action_pressed("ui_cancel") and is_playing:
		game_over()
		
	if event.is_action_pressed("ui_cancel") and not is_playing:
		var _scene = get_tree().change_scene("res://ui/pages/pre_game.tscn")
	
	if Input.is_action_pressed("0"):
		user_key = "0"
	if Input.is_action_pressed("1"):
		user_key = "1"
	if Input.is_action_pressed("2"):
		user_key = "2"
	if Input.is_action_pressed("3"):
		user_key = "3"
	if Input.is_action_pressed("4"):
		user_key = "4"
	if Input.is_action_pressed("5"):
		user_key = "5"
	if Input.is_action_pressed("6"):
		user_key = "6"
	if Input.is_action_pressed("7"):
		user_key = "7"
	if Input.is_action_pressed("8"):
		user_key = "8"
	if Input.is_action_pressed("9"):
		user_key = "9"
	if user_key and is_waiting_answer:
		get_key(user_key)
		

#func get_key_numpad():
#	var key_numpad = $Numpad.key_bt
#	get_key(key_numpad)

func _on_Numpad_numpad_button_pressed(key_numpad):
		get_key(str(key_numpad))


func get_key(user_key):
	var nb_qst = get_questions_count()
	if nb_qst > 0:
		list_user_keys.append(user_key)
		print("touche: ",user_key, "liste keys: ", list_user_keys)
		check_user_answer()

func check_user_answer():
	current_user_answer = ""
	for i in list_user_keys:
		current_user_answer += i
	display_user_answer()
	
	if current_user_answer.length()>=current_expected_answer.length():
		print("response user: ", list_user_keys)
		if current_user_answer == current_expected_answer:
			right_answer()
		else:
			wrong_answer()
		list_user_keys = []
		
func right_answer():
	print("réponse juste")
	score += 1
	var still_parts = $Puzzle.hide_one_part()
	if not still_parts:
		$Bg.choose_background()
		$Puzzle.display_all_parts()
	$HUD.update_score(score)
	$GoodAnswerSound.play()
	var nb_qst = get_questions_count()
	
	#test si il n'y a plus qu'une seule  questions à l'écran
	if nb_qst == 1:
		questTimer_next_step(0.5)
	
	select_quest_to_active_after_user_imput()

func wrong_answer():
	print("réponse utilisateur fausse. la réponse était : ", current_expected_answer)
	nb_lives -= 1
	$HUD.update_lives(nb_lives)
	$DeathSound.play()
	current_body.set_animation("wrong")
	is_waiting_answer = false
	current_body.zero_gravity()
	current_body.display_answer()
	#print("colision: ",body)
	$DisplayAnswerTimer.start()

func display_user_answer():
	var format_user_answer = format_user_answer(current_user_answer, current_expected_answer)
	$HUD.update_user_answer(format_user_answer)

func select_quest_to_active_after_user_imput():
	pre_current_body = current_body
	var lst_qst = get_list_questions()
	if len(lst_qst) > 1:
		#on va activer la question suivante lst_qst[1]. 
		#pas celle courante lst_qst[0] car celle-ci va être détruite
		#le fait d'activer la question suivante avant de détruire l'autre
		#permet d'éviter les problèmés d'accés à des objets détruit mais qui existe encore un laps de temps
		active_the_question(lst_qst[1])	
		destroy_pre_active_question()
	else:
		is_question_active = false
		destroy_pre_active_question()

func _on_DisplayAnswerTimer_timeout():
	questTimer_next_step(0.5)
	current_body.queue_free()
	if nb_lives <= 0:
		print("game over")
		game_over()
	else:
		$HUD.update_user_answer("")
		pre_current_body = current_body
		select_quest_to_active_after_user_imput()

func _on_Area2D_body_entered(body):
	#ce déclenche quand la question touche le sol
	current_body = body
	wrong_answer()
	
func _on_quest_timer_timeout():
	pick_a_question()

func questTimer_next_step(time_sec):
	#permet de racourcir le temps restant à time_sec 
	# afin de déclencher le timeout plus rapidement
	$QuestTimer.stop()
	$QuestTimer.wait_time = time_sec
	$QuestTimer.start()
	$QuestTimer.wait_time = current_QuestTimer_wait_time
	
func pick_a_question():
	#instanciation de l'objet question.
	nb_question += 1
	if (nb_question % nb_question_for_a_step) == 0:
		update_game_difficultie()
	var qst = questions_scn.instance()
	add_child(qst)
	var qsz = qst.get_question_size()
	var posx =position_the_question(qsz)
	var pos = Vector2(posx,0)
	
	#récupération de la question
	var question_datas  = qst.choose_question() #je passe par une liste pour récupérer les valeurs car je ne suis pas arrivé que la fonction me renvoie des valeurs multiples ;(
	#var question_datas  = choose_multiplication_question()
	
	var expected_answer = question_datas[0]
	var question = question_datas[1]

	qst.set_answer(expected_answer)
	qst.set_question(question)
	qst.update_speed(question_speed)
	
	qst.display_question()
	#qst.linear_velocity = Vector2(0,100)	#donne la vitesse de chute de la question
	qst.init(pos)
	var questions = get_list_questions()
	print("liste des questions : ", questions)
	if not is_question_active:
		print("ACTIVATION LORS DE PICK_A_QUESTION")
		var lst_quest = get_list_questions()
		active_the_question(lst_quest[0])

func position_the_question(var qsz):
	var posx = (randf() * (screen_size.x - qsz.x)) +  (qsz.x /2)
	return posx

func format_user_answer(user_anwser, expected_answer):
	#dans la zone de saisie utilisateur.
	#affiche des tirets  à la place des caractères pas encore saisis par l'utilisateur.
	#cela aide le joueur à savoir comboien de digits sont attendus.
	#par exemple si la réponse attendue est 134 la zone de saisie affichera d'abord '---' puis par ex '1--' puis '13-' puis '134'.
	var format_user_answer =""
	var len_exp_ans = expected_answer.length()
	var len_user_ans = user_anwser.length()
	var nb_trema = len_exp_ans - len_user_ans
	format_user_answer = "-".repeat(nb_trema) + user_anwser
	return format_user_answer

func destroy_pre_active_question():
	pre_current_body.queue_free()

func destroy_one_question(q):
	q.queue_free()

func game_over():
	is_playing = false
	$QuestTimer.stop()
	get_tree().call_group("questions", "queue_free")
	$HUD.show_game_over()
	$HUD.update_user_answer("")
	
func active_the_question(qst):
	is_question_active = true
	current_body = qst
	qst.set_animation("active")
	current_question = qst.get_question()
	current_expected_answer = qst.get_answer()
	print("reset user answer")
	current_user_answer = ""
	list_user_keys = []
	is_waiting_answer = true
	display_user_answer()

func get_list_questions():
	var questions = get_tree().get_nodes_in_group("questions")
	return questions
	
func get_questions_count():
	var q = get_list_questions()
	var nb_q  = len(q)
	return nb_q
	
func update_game_difficultie():
	question_speed = question_speed * 1.2
	$QuestTimer.wait_time =evaluate_quest_timer()
	
	update_display_wrong_timer()
	print("TTTTTTTTTTTTTTTTTTTTTTTTTTTT")
	print("nb quest: ", nb_question, "quest speed: ", question_speed, "quest timer: ", $QuestTimer.wait_time)
	
func update_display_wrong_timer():
	if $DisplayAnswerTimer.wait_time <= $QuestTimer.wait_time * 1.5:
		$DisplayAnswerTimer.wait_time = $DisplayAnswerTimer.wait_time * .7

func evaluate_quest_timer():
	#petit calcul pour que la fréquece des questions soit légerement plus élevée que la durée de chute
	var quest_time = (1.0/(question_speed+1))* 300
	print("*******QUESTION TIMER*************",quest_time) 
	print("*******question_speed*************",question_speed) 
	current_QuestTimer_wait_time = quest_time
	return quest_time



