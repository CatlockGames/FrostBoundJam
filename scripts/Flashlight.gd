extends "res://scripts/Interactable.gd"

func _ready():
	type = InteractableTypes.PICKABLE
	text = "flashlight"

func interact():
	player.take(self)
	player.say("Ah, the classic yellow flashlight.")
	queue_free()

func onAnimationFinished(animName):
	pass