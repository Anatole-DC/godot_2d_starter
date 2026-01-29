extends Node

@onready var label = $CanvasLayer/HBoxContainer/Label

var score = 0

func add_point():
	score += 1
	label.text = "You collected " + str(score) + " coins"
