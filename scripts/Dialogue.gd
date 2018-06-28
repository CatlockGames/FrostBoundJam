extends RichTextLabel

var dialogueQueue = []
var currentDialogue = ""
var charIndex = 0

func _ready():
	$Timer.connect("timeout", self, "onTimeout")
	$AnimationPlayer.connect("animation_finished", self, "onAnimationFinished")

func addDialogue(dialogue):
	dialogueQueue.append(dialogue)
	$Timer.start()

func onTimeout():
	if(currentDialogue.length() < dialogueQueue[0].length()):
		currentDialogue += dialogueQueue[0][charIndex]
		bbcode_text = "[center]" + currentDialogue + "[center]"
		charIndex += 1
	else:
		dialogueQueue.pop_front()
		$Timer.stop()
		var timer = Timer.new()
		timer.set_one_shot(true)
		timer.set_wait_time(1)
		timer.connect("timeout", self, "fadeOut")
		timer.start()
		add_child(timer)

func fadeOut():
	$AnimationPlayer.play("fadeOut")

func onAnimationFinished(animName):
	if(animName == "fadeOut"):
		currentDialogue = ""
		bbcode_text = ""
		charIndex = 0
		modulate.a = 1
		if(dialogueQueue.size() != 0):
			$Timer.start()