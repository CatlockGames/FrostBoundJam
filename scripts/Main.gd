extends Node

const splash = preload("res://scenes/SplashScreen.tscn")
var splashInstance = null

signal loadingFinished

var config = ConfigFile.new()
const configPath = "res://settings.cfg"

# Video
var width = 1280
var height = 720
var borderless = false
var fullscreen = true
var vsync = true

# Audio
var music = true
var musicVolume = 0
var sfx = true
var sfxVolume = 0

# Input
var bindings = {
	"moveLeft": "Left",
	"moveRight": "Right",
	"moveUp": "Up",
	"moveDown": "Down",
	"interact": "Z",
	"inventory": "X"
}

# Gameplay
# ???

func _ready():
	splashInstance = splash.instance()
	add_child(splashInstance)
	loadData()

# load data (config, saves, etc.)
func loadData():
	# load data here
	loadConfig()
	applyConfig()
	print("OK: finished loading data.")
	emit_signal("loadingFinished")

func applyConfig():
	# Video
	OS.window_size = Vector2(width, height)
	OS.window_borderless = borderless
	OS.window_fullscreen = fullscreen
	OS.vsync_enabled = vsync
	
	# Audio
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !music)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), musicVolume)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), !sfx)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfxVolume)
	
	# Input
	for action in bindings.keys():
		var event = InputEventKey.new()
		event.scancode = OS.find_scancode_from_string(bindings[action])
		for oldEvent in InputMap.get_action_list(action):
			if(oldEvent is InputEventKey):
				InputMap.action_erase_event(action, oldEvent)
		InputMap.action_add_event(action, event)
	
	print("OK: config applied")

func loadConfig():
	var err = config.load(configPath)
	if(err == OK):
		# Video
		setFromConfig("video", "width")
		setFromConfig("video", "height")
		setFromConfig("video", "borderless")
		setFromConfig("video", "fullscreen")
		setFromConfig("video", "vsync")
		
		# Audio
		setFromConfig("audio", "music")
		setFromConfig("audio", "musicVolume")
		setFromConfig("audio", "sfx")
		setFromConfig("audio", "sfxVolume")
		
		# Input
		for action in bindings.keys():
			if(config.has_section_key("input", action)):
				bindings[action] = config.get_value("input", action)
			else:
				print("WARN: no binding found for " + action + ", default value written")
				config.set_value("input", action, bindings[action])
		
		config.save(configPath)
		print("OK: config loaded")
	else:
		# Video
		config.set_value("video", "width", width)
		config.set_value("video", "height", height)
		config.set_value("video", "borderless", borderless)
		config.set_value("video", "fullscreen", fullscreen)
		config.set_value("video", "vsync", vsync)
		
		# Audio
		config.set_value("audio", "music", music)
		config.set_value("audio", "musicVolume", musicVolume)
		config.set_value("audio", "sfx", sfx)
		config.set_value("audio", "sfxVolume", sfxVolume)
		
		# Input
		for action in bindings.keys():
			config.set_value("input", action, bindings[action])
		
		config.save(configPath)
		print("ERROR: config not found, defaults written")

func setFromConfig(section, key):
	if(config.has_section_key(section, key)):
		set(key, config.get_value(section, key))
	else:
		print("WARN: " + key + " is missing from " + section + ", default value written")
		config.set_value(section, key, get(key))