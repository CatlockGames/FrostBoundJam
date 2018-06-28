extends Control

export (PackedScene) var nextScene

var loadingFin = false
var logoEntered = false

func _ready():
	get_parent().connect("loadingFinished", self, "onLoadingFinished")
	$AnimationPlayer.connect("animation_finished", self, "onAnimationFinished")

func onLoadingFinished():
	loadingFin = true
	if(logoEntered):
		$AnimationPlayer.play("logoExit")
	$Loading.visible = false

func onAnimationFinished(animName):
	if(animName == "logoEnter"):
		if(loadingFin):
			$AnimationPlayer.play("logoExit")
		logoEntered = true
	if(animName == "logoExit"):
		get_parent().add_child(nextScene.instance())
		queue_free()

func playPortalSound():
	$Logo/AudioStreamPlayer.play()
	$Logo/AudioStreamPlayer
