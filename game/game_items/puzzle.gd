extends Node2D
var puzzlePart_scn = preload("res://game/game_items/PuzzlePart.tscn")

var nb_parts = 20
var cpt_parts = 0
var list_parts = []


func _ready():
	pass # Replace with function body.

func init():
	pass

func create_the_puzzle():
	var path = "res://game/game_assets/puzzle/"
	for i in range(20):
		var part = puzzlePart_scn.instance()
		add_child(part)
		
		var current_file = "P"+str(i+1)+".png"
		var path_and_file = path +"/" + current_file
		part.init(path_and_file)
		list_parts.append(part)

func hide_one_part():
	var still_parts = true
	cpt_parts += 1
	
	print("***** NB PARTS ******", cpt_parts, " / ", nb_parts)
	if cpt_parts <= (nb_parts):
		list_parts[cpt_parts-1].hide()
		still_parts = true
	
	if cpt_parts > nb_parts:
		cpt_parts = 0
		still_parts = false
	
	
	
	return still_parts
		
		
	

func display_all_parts():
	shuffle_the_puzzle()
	cpt_parts = 0
	for i in list_parts:
		i.display()

func hide_all_parts():
	for i in list_parts:
		i.hide()

func shuffle_the_puzzle():
	list_parts.shuffle()

