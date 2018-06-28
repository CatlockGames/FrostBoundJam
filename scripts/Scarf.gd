extends "res://scripts/Interactable.gd"

func _ready():
	type = InteractableTypes.PICKABLE
	text = "scarf"

func interact():
	player.miscDecay += 1.0
	player.take(self)
	player.say("A warm scarf, how comforting.")
	queue_free()

func onAnimationFinished(animName):
	pass