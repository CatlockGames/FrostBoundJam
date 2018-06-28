extends "res://scripts/Interactable.gd"

func _ready():
	type = InteractableTypes.PICKABLE
	text = "screwdriver"

func interact():
	player.take(self)
	player.say("A nice durable screwdriver.")
	queue_free()

func onAnimationFinished(animName):
	pass
