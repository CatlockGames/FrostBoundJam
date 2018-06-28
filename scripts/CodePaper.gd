extends "res://scripts/Interactable.gd"

func _ready():
	type = InteractableTypes.PICKABLE
	text = "note: 3141"

func interact():
	player.take(self)
	player.say("The note reads 3141.")
	queue_free()

func onAnimationFinished(animName):
	pass