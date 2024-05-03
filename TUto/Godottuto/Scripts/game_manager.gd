extends Node

var score = 0
@onready var score_label = $ScoreLabel

func AddPoint():
	score += 1
	score_label.text = "Your Coins: " + str(score)
