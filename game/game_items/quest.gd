#extends StaticBody2D
extends KinematicBody2D

var question_string = ""	#chaine représentant la question
var answer_string = ""					#valaur représenant la réponse attendue
#var moving = true
var speed = 150

func init(pos):
	position = pos
	print("création question")
	print("position:",pos)
	

func _process(delta):
	var velocity = Vector2()
	velocity.y += speed
	position += velocity * delta

func get_question_size():
	var s= $AnimatedSprite.get_sprite_frames().get_frame("active",0).get_size()
	var sc= $AnimatedSprite.scale
	var sz = s * sc
	return sz
	
func set_question(text):
	question_string = text
	
func get_question():
	return question_string
	
func set_answer(text):
	answer_string = text
	
func get_answer():
	return answer_string
	
func display_question():
	$Label.text = question_string

func display_answer():
	print(answer_string)
	$Label.text = answer_string
	$AnimatedSprite.animation = "wrong"

func set_animation(text):
	$AnimatedSprite.animation = text

func zero_gravity():
	speed = 25

func update_speed(sp):
	speed = sp

func choose_question():
	var question_datas
	if GlobalVariables.current_preset["type"] == "calculated_by_computer":
		print("calculated_by_computer")
		question_datas = choose_question_calculated_by_computer()
		print ("choosen question : ",question_datas)
	else:
		print("question de type inconnue")
		get_tree().quit()
	return question_datas

func choose_question_calculated_by_computer():
	# choisi un question du type: calculated_by_computer
	var q_datas
	var is_max_result = true
	var max_result = GlobalVariables.current_preset["max_result"]
	#var min_result = GlobalVariables.current_preset["min_result"]
	var coef_mulitiplier = GlobalVariables.current_preset["coef_multiplier"]
	print("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM")
	print(coef_mulitiplier)
	if max_result == 0:
		is_max_result = false
	var max_values = GlobalVariables.current_preset["max_values"]
	var min_values = GlobalVariables.current_preset["min_values"]
	if min_values == []: 
		min_values = [1,1]
	var operators = GlobalVariables.current_preset["operators"]
	var expected_answer = ""
	var choosen_question = ""
	var q=[0,0]
	var operator = ""
	var result = -1 
	var calcul_datas = {}
	
	while 1:
		q[0] = int(rand_range(min_values[0],max_values[0]+1))*coef_mulitiplier[0] 	#opérande a
		#q[0] = int(rand_range(min_values[0],max_values[0]+1)) 	#opérande a
		q[1] = int(rand_range(min_values[1],max_values[1]+1))*coef_mulitiplier[1] 	#opérande b
		#q[1] = int(rand_range(min_values[1],max_values[1]+1)) 	#opérande b
		operator = operators[int(rand_range(0,len(operators)))]			#choisi un opérateur parmi la les opérateur présents dans le chaine de caractère 'operators'

		calcul_datas = calulate_by_operators(q,operator)
		result = calcul_datas['result']
#
#		print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
#		print("is_max_result : ",is_max_result)
#		print("result : ",calcul_datas['result'])
#		print("q : ",q)
#		print("choosen_question",calcul_datas["choosen_question"])
#		print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
		if result <= max_result or not is_max_result:
			break
	
	expected_answer = str(result)
	choosen_question = calcul_datas["choosen_question"]
	q_datas = [expected_answer, choosen_question]
	return q_datas
	
func calulate_by_operators(ops,operator):
	print("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO")
	print(ops,":",operator)
	var calcul_datas = {}
	var result = 0
	var choosen_question = ""
	
	if operator == ("+"):
		result = ops[0] + ops[1]
		choosen_question = str(ops[0]) + "+" + str(ops[1])
	elif operator == ("-"):
		var op0
		var op1
		if ops[0] >= ops[1]:
			op0 = ops[0]
			op1 = ops[1]
		else:
			op0 = ops[1]
			op1 = ops[0]
		result = op0 - op1
		choosen_question = str(op0) + "-" + str(op1)
	elif operator == ("*"):
		result = ops[0] * ops[1]
		choosen_question = str(ops[0]) + "x" + str(ops[1])
	elif operator == ("/"):
		var op0 = ops[0] * ops[1]
		var op1 = ops[0]
		result = ops[1]
		choosen_question = str(op0) + "/" + str(op1)
	else:
		print("opérateur inconnu... : ", operator)
		get_tree().quit()
	
	calcul_datas["result"] = result
	calcul_datas["choosen_question"] = choosen_question
	return calcul_datas


