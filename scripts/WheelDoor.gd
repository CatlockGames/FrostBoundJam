extends "res://scripts/Door.gd"

func _ready():
#	topStartPos = Vector2(3, -28)
#	topEndPos = Vector2(-2, 58)
#	bottomStartPos = Vector2(3, 30)
#	bottomEndPos = Vector2(-2, -56)
	tweenDuration = 3.5

func interact():
	if(player.has(["Pipe"])):
		open()
	else:
		player.say("Hm... I need some leverage.")