extends "res://scripts/Interactable.gd"

func _ready():
	type = InteractableTypes.PICKABLE

func interact():
	print(name + " interact")
