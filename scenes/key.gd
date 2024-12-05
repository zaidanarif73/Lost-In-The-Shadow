extends Node3D

var mission_successful = false  # Flag to track if the mission is already successful

# Called when the node enters the scene tree for the first time.
func get_player() -> CharacterBody3D:
	var current_node = self
	while current_node != null:  # Traverse upwards until we find CharacterBody3D or reach the root
		if current_node is CharacterBody3D:
			return current_node
		current_node = current_node.get_parent()
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = get_player()
	
	# Detect if the player is in the victim box area
	if player and player.victim.is_touching_player:
		# Use skill if entering the key mode
		if Input.is_action_just_pressed("skill") and visible:
			player.victim.loading.visible = true
			
		# Check for success and print only once
		if player.victim.loading.success and not mission_successful:
			player.victim.animation_player.play('stand')
			player.victim.victim_is_free = true
			mission_successful = true  # Set the flag to true to prevent further prints
