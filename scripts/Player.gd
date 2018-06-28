extends KinematicBody2D

var active = true

# Movement
var direction = Vector2()
var lastDirection = Vector2()
var velocity = Vector2()
var walkSpeed = 50
var acceleration = 10
var deceleration = 20

# Stats
var health = 100
var maxHealth = 100
var temperature = 100
var maxTemperature = 100

# Temperature Decay
var decay = 0.0
var outsideDecay = -2.0
var insideDecay = 2.0
var miscDecay = 0.0
var speedFactor = 1.0

const Interactable = preload("res://scripts/Interactable.gd")
var interactables = []

func _ready():
	$Interaction.connect("area_entered", self, "onAreaEntered")
	$Interaction.connect("area_exited", self, "onAreaExited")
	$Timer.connect("timeout", self, "onTimeout")

func _process(delta):
	pass

func _physics_process(delta):
	direction = Vector2()
	if(active):
		if(Input.is_action_pressed("moveLeft")):
			direction -= Vector2(1, 0)
		if(Input.is_action_pressed("moveRight")):
			direction += Vector2(1, 0)
		if(Input.is_action_pressed("moveUp")):
			direction -= Vector2(0, 1)
		if(Input.is_action_pressed("moveDown")):
			direction += Vector2(0, 1)
		if(Input.is_action_just_pressed("interact")):
			if(!interactables.empty() && interactables.back().enabled):
				changeAnimation("interact")
				interactables.back().interact()
		if(Input.is_action_just_pressed("inventory")):
			$Inventory.showInventory()
		if(Input.is_action_just_released("inventory")):
			$Inventory.hideInventory()
	direction = direction.normalized()
	if(direction.length() != 0):
		lastDirection = direction
		$Sprite.rotation = lastDirection.angle() + PI / 2
		changeAnimation("walk")
	else:
		changeAnimation("idle")
	var targetVelocity = direction * walkSpeed * speedFactor
	var accel = acceleration
	if(direction.dot(targetVelocity) < 0):
		accel = deceleration
	velocity = velocity.linear_interpolate(targetVelocity, accel * delta)
	velocity = move_and_slide(velocity)

func changeAnimation(animation):
	if($AnimationPlayer.current_animation != animation):
		$AnimationPlayer.play(animation)

func take(item):
	$Inventory.addItem(item)

func say(dialogue):
	$Dialogue.addDialogue(dialogue)

func has(items):
	var hasItems = true
	for item in items:
		if(!$Inventory.items.has(item)):
			hasItems = false
			break
	return hasItems

func hideSprite():
	$Sprite.modulate.a = 0

func showSprite():
	$Sprite.modulate.a = 1

func setInside():
	$SnowCCW.emitting = false
	$SnowCW.emitting = false
	decay = insideDecay + miscDecay

func setOutside():
	$SnowCCW.emitting = true
	$SnowCW.emitting = true
	decay = outsideDecay + miscDecay

func onTimeout():
	temperature += decay
	if(temperature > maxTemperature):
		temperature = maxTemperature
	speedFactor = temperature / maxTemperature
	$AnimationPlayer.playback_speed = speedFactor

func onAreaEntered(area):
	if(area is Interactable && area.enabled):
		interactables.append(area)
		rehighlight()

func onAreaExited(area):
	if(area is Interactable):
		area.unhighlight()
		interactables.erase(area)
		rehighlight()

func rehighlight():
	for area in interactables:
		area.unhighlight()
	if(!interactables.empty()):
		interactables.back().highlight()