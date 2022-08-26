extends Node2D


func _ready():
	pass # Replace with function body.


func init(texture):
	print(texture)
	$PartRect.texture = load(texture)

func display():
	$PartRect.visible = true

func hide():
	$PartRect.visible = false
