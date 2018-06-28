extends Node2D

var Player = preload("res://scripts/Player.gd")
onready var player = get_tree().get_nodes_in_group("player")[0]

func _ready():
	$FadeIn.connect("tween_completed", self, "onFadeInFinished")
	$FadeOut.connect("tween_completed", self, "onFadeOutFinished")
	$Blueprint.connect("area_entered", self, "onAreaEntered")
	$Blueprint.connect("area_exited", self, "onAreaExited")
	exit()

func enter():
	player.setInside()
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Ambient"), 0, true)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambient"), -20)
	$FadeOut.interpolate_property($Roof, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.75, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$FadeOut.start()

func exit():
	player.setOutside()
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Ambient"), 0, false)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambient"), -10)
	$Floor/LightOccluder2D.visible = false
	$FadeIn.interpolate_property($Roof, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.75, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$FadeIn.start()

func onFadeInFinished(object, key):
	$FadeIn.remove(object, key)

func onFadeOutFinished(object, key):
	$Floor/LightOccluder2D.visible = true
	$FadeOut.remove(object, key)

func onAreaEntered(area):
	if(area.get_parent() is Player):
		enter()

func onAreaExited(area):
	if(area.get_parent() is Player):
		exit()