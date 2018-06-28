extends Control

var items = []
var currentIndex = 0
var fade

func _ready():
	$Timer.connect("timeout", self, "onTimeout")

func addItem(item):
	if(items.empty()):
		$Items/Nothing.free()
	items.append(item.name)
	var node = Label.new()
	node.text = "- " + item.text
	node.modulate.a = 0
	node.light_mask = 0
	$Items.add_child(node)

func showInventory():
	fade = "in"
	$Timer.start()

func hideInventory():
	fade = "out"
	$Timer.start()

func onTimeout():
	var currentItem = $Items.get_child(currentIndex)
	var tween = Tween.new()
	if(fade == "in"):
		tween.interpolate_property(currentItem, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		currentIndex += 1
	elif(fade == "out"):
		tween.interpolate_property(currentItem, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		currentIndex -= 1
	tween.connect("tween_completed", self, "onTweenCompleted", [tween])
	tween.start()
	currentItem.add_child(tween)
	if(currentIndex == $Items.get_children().size()):
		currentIndex -= 1
		$Timer.stop()
	if(currentIndex == -1):
		currentIndex += 1
		$Timer.stop()

func onTweenCompleted(object, key, tween):
	tween.remove(object, key)