extends Control

# Variables to hold button nodes
var start_button
var about_button
var exit_button

func _ready() -> void:
	# Check the platform to determine which buttons to use
	if OS.has_feature("touchscreen"):
		# Mobile: Use TouchScreenButton
		start_button = $BG/MobileButton/StartTouchButton
		about_button = $BG/MobileButton/AboutTouchButton
		exit_button = $BG/MobileButton/ExitTouchButton
	else:
		# PC: Use TextureRect
		start_button = $BG/HSplitContainer/PcButton/startButton
		about_button = $BG/HSplitContainer/PcButton/aboutButton
		exit_button = $BG/HSplitContainer/PcButton/exitButton

	# Log to confirm the nodes are found
	print("Start button: ", start_button)
	print("About button: ", about_button)
	print("Exit button: ", exit_button)

	# Connect signals to handle button actions
	if start_button and about_button and exit_button:
		start_button.connect("pressed", Callable(self, "_on_start_pressed"))
		about_button.connect("pressed", Callable(self, "_on_about_pressed"))
		exit_button.connect("pressed", Callable(self, "_on_exit_pressed"))
	else:
		print("Error: One or more buttons are null!")

# Function to handle start button
func _on_start_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/level_001.tscn")
	get_tree().change_scene_to_file("res://scenes/video_prolog.tscn")

# Function to handle about button
func _on_about_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/about.tscn")

# Function to handle exit button
func _on_exit_pressed() -> void:
	get_tree().quit()
