extends "res://scripts/Interactable.gd"

func _ready():
	type = InteractableTypes.PICKABLE
	text = "pipe"

func interact():
	player.take(self)
	player.say("A sturdy steel pipe.")
	queue_free()

func onAnimationFinished(animName):
	pass