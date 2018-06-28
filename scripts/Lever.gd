extends "res://scripts/Interactable.gd"

func _ready():
	type = InteractableTypes.CONDITIONAL
	$AnimationPlayer.play("idle")

func interact():
	player.interactables.erase(self)
	unhighlight()
	$AnimationPlayer.play("pull")
	enabled = false

func onAnimationFinished(animName):
	if(animName == "pull"):
		$AnimationPlayer.play("idle")
