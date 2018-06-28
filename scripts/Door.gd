extends "res://scripts/Interactable.gd"

var interactStartPos = Vector2()
var interactEndPos = Vector2()

var tweenDuration

func _ready():
	type = InteractableTypes.CONDITIONAL
	$PreTween.connect("tween_completed", self, "onPreTweenCompleted")
	$Tween.connect("tween_completed", self, "onTweenCompleted")

func open():
	unhighlight()
	for area in $TopTrigger.get_overlapping_areas():
		if(area.get_parent() is Player):
			interactStartPos = $TopStart.global_position
			interactEndPos  = $TopEnd.global_position
	for area in $BottomTrigger.get_overlapping_areas():
		if(area.get_parent() is Player):
			interactStartPos = $BottomStart.global_position
			interactEndPos = $BottomEnd.global_position
	$PreTween.interpolate_property(player, "position", player.global_position, interactStartPos, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$PreTween.start()
	player.active = false
	$StaticBody2D/CollisionShape2D.disabled = true

func onPreTweenCompleted(object, key):
	$PreTween.remove(object, key)
	player.hideSprite()
	if(interactStartPos == $TopStart.global_position):
		$AnimationPlayer.play("openTop")
	else:
		$AnimationPlayer.play("openBottom")
	$Tween.interpolate_property(player, "position", player.global_position, interactEndPos, tweenDuration, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.start()

func onTweenCompleted(object, key):
	$Tween.remove(object, key)

func onAnimationFinished(animName):
	if(animName == "openTop" || animName == "openBottom"):
		player.global_position = interactEndPos
		player.showSprite()
		player.active = true
		$AnimationPlayer.play("idle")
		$StaticBody2D/CollisionShape2D.disabled = false