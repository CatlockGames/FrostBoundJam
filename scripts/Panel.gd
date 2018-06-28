extends "res://scripts/Interactable.gd"

func _ready():
	type = InteractableTypes.CONDITIONAL
	$AnimationPlayer.play("idleUp")

func interact():
	player.interactables.erase(self)
	unhighlight()
	$AnimationPlayer.play("fall")
	enabled = false
	$StaticBody2D/CollisionShape2D.disabled = true
	$LightOccluder2D.visible = false

func onAnimationFinished(animName):
	if(animName == "fall"):
		$AnimationPlayer.play("idleDown")