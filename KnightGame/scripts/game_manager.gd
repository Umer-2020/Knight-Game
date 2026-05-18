extends Node

var score = 0
@onready var score_label: Label = $scoreLabel

func add_point():
	score += 1
	print("Your Score: ", score)  # Godot is auto-converting score from int->str	
	score_label.text = "You Collected " + str(score) + "/11 Coins"
