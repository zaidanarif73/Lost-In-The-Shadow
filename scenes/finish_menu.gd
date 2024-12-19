extends Control

var back_button

func _ready() -> void:
	back_button = $TextureRect/backButton

	# Log to confirm the node is found
	print("Back button: ", back_button)

	# Connect signal to handle back button action
	if back_button:
		back_button.connect("pressed", Callable(self, "_on_back_pressed"))
	else:
		print("Error: Back button is null!")

# Function to handle back button press
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
