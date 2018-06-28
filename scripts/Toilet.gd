extends "res://scripts/Interactable.gd"

func _ready():
	type = InteractableTypes.CONDITIONAL

func interact():
	$AudioStreamPlayer2D.play()

func onAnimationFinished(animName):
	pass