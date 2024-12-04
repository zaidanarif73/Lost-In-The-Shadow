extends Node3D

@onready var player = Player
# Called when the node enters the scene tree for the first time.
func get_player() -> CharacterBody3D:
	var current_node = self
	while current_node != null:  # Traverse upwards until we find CharacterBody3D or reach the root
		if current_node is CharacterBody3D:
			return current_node
		current_node = current_node.get_parent()
	return null

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("skill") and visible:
		var player = get_player()  # Get the player instance
		if player and player.has_method("increase_health"):
			player.increase_health(25.0)  # Increase healthes
			print("Medkit used! Player's health increased.")
	
