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
var display_quesion_timer_wait_time_init = 1

var nb_question = 0
var step_difficultie = 0
var nb_question_for_a_step = 20


var screen_size
var current_body		#pointe vers le dernier body qui a été en collision

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
	
func calculate_question_speed():
	var key = "percent_speed-level" + str(GlobalVariables.level)
	var preset_speed = GlobalVariables.current_preset[key]
	var ratio = 200
	question_speed_init = int((preset_speed+1)/100 * ratio)
	print("#################################")
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
		

func get_key_numpad():
	var key_numpad = $Numpad.key_bt
	get_key(key_numpad)
	

func get_key(user_key):
	var is_qst = check_quest_exist()
	if is_qst:
		list_user_keys.append(user_key)
		print("touche: ",user_key, "liste keys: ", list_user_keys)
		check_user_answer()

func check_quest_exist():
	var exist = true
	var q = get_list_questions()
	var nb_q  = len(q)
	if nb_q ==0:
		exist = false
	return exist
	
	
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
	
	current_body.queue_free()
	
	$delayActiveQuestionTimer.start()

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
	$DisplayQuestionTimer.start()

func display_user_answer():
	var format_user_answer = format_user_answer(current_user_answer, current_expected_answer)
	$HUD.update_user_answer(format_user_answer)
	
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


func _on_quest_timer_timeout():
	pick_a_question()

func position_the_question(var qsz):
	var posx = (randf() * (screen_size.x - qsz.x)) +  (qsz.x /2)
	return posx

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
	$DisplayQuestionTimer.wait_time = display_quesion_timer_wait_time_init
	
	display_user_answer()
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.update_lives(nb_lives)
	$HUD.show_message("Get Ready")

func _on_StartTimer_timeout():
	pick_a_question()
	$QuestTimer.start()
	print("début de la partie")
	
func choose_question():
	#a+b = c
	var max_result = 10
	var expected_answer = ""
	var choosen_question = ""
	var q=[0,0,0]
	var result = -1
	while result <0 or result > 10:
		q[0] = int(rand_range(1,9)) 	#opérande a
		q[1] = int(rand_range(1,9)) 	#opérande b
		q[2]= q[0] + q[1]			 	#résultat c
		result = q[2]
	
	expected_answer = str(q[2])
	choosen_question = str(q[0]) + "+" + str(q[1])
	var question_datas = [expected_answer, choosen_question]
	print ("choose question : ",question_datas)
	return question_datas
	
func choose_multiplication_question():
	#a*b = c
	var expected_answer = ""
	var choosen_question = ""
	var q=[0,0,0]
	q[0] = int(rand_range(1,10)) 	#opérande a
	q[1] = int(rand_range(1,11)) 	#opérande b
	q[2]= q[0] * q[1]			 	#résultat c
	expected_answer = str(q[2])
	choosen_question = str(q[0]) + "x" + str(q[1])
	var question_datas = [expected_answer, choosen_question]
	print ("choose question : ",question_datas)
	return question_datas

func _on_Area2D_body_entered(body):
	current_body = body
	wrong_answer()
	
func game_over():
	is_playing = false
	$QuestTimer.stop()
	get_tree().call_group("questions", "queue_free")
	$HUD.show_game_over()
	$HUD.update_user_answer("")

func _on_DisplayQuestionTimer_timeout():
	current_body.queue_free()
	if nb_lives <= 0:
		print("game over")
		game_over()
	else:
		$HUD.update_user_answer("")
		$delayActiveQuestionTimer.start()

func _on_delayActiveQuestionTimer_timeout():
	select_question_to_active()

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
	if len(questions) == 1:
		print("ACTIVATION LORS DE PICK_A_QUESTION")
		select_question_to_active()

func select_question_to_active():
	#cette fonction va activer la bonne question (celle la plus basse)
	var questions = get_list_questions()
	if len(questions)>0:
		var qst = questions[0]
		print("questions: ", len(questions) , questions)
		active_the_question(qst)
		
func get_list_questions():
	var questions = get_tree().get_nodes_in_group("questions")
	return questions
	
func active_the_question(qst):
	current_body = qst
	qst.set_animation("active")
	current_question = qst.get_question()
	current_expected_answer = qst.get_answer()
	print("reset user answer")
	current_user_answer = ""
	list_user_keys = []
	is_waiting_answer = true
	display_user_answer()
	
func update_game_difficultie():
	question_speed = question_speed * 1.2
	$QuestTimer.wait_time =evaluate_quest_timer()
	update_display_wrong_timer()
	print("TTTTTTTTTTTTTTTTTTTTTTTTTTTT")
	print("nb quest: ", nb_question, "quest speed: ", question_speed, "quest timer: ", $QuestTimer.wait_time)
	
func update_display_wrong_timer():
	if $DisplayQuestionTimer.wait_time <= $QuestTimer.wait_time * 1.5:
		$DisplayQuestionTimer.wait_time = $DisplayQuestionTimer.wait_time * .7

func evaluate_quest_timer():
	#petit calcul pour que la fréquece des questions soit légerement plus élevée que la durée de chute
	var quest_time = (1.0/(question_speed+1))* 300
	print("*******QUESTION TIMER*************",quest_time) 
	print("*******question_speed*************",question_speed) 
	return quest_time

func print_hello():
	print("HELLLLLLLOOOOOO")
