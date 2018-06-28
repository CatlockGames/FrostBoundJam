extends Area2D

enum InteractableTypes {PICKABLE, CONDITIONAL}
var type
var enabled = true
var text = ""

var Player = preload("res://scripts/Player.gd")
onready var player = get_tree().get_nodes_in_group("player")[0]

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "onAnimationFinished")
	$Highlight.hide()

func highlight():
	$Highlight.show()

func unhighlight():
	$Highlight.hide()