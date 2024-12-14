extends Area3D

@onready var player = $"../CharacterBody3D"
@onready var victim = $"../maps/Victim"
@onready var finish_area = $"."
@onready var ground = $"../maps/obj1"  # Reference to your ground mesh

var player_in_area = false
var victim_in_area = false

# Variables to store the ground's size and bounds
var spawn_area_min = Vector3.ZERO
var spawn_area_max = Vector3.ZERO

func _ready() -> void:
	# Calculate the bounds of the ground mesh
	if ground and ground is MeshInstance3D:
		var ground_aabb = ground.get_aabb()  # Get the ground's AABB (Axis-Aligned Bounding Box)
		
		spawn_area_min = ground_aabb.position  # Position of the ground's lower-left corner
		spawn_area_max = ground_aabb.position + ground_aabb.size  # Upper-right corner based on the size
		
		# Spawn the finish area at a random position within the ground bounds
		var random_position = Vector3(
			randf_range(spawn_area_min.x, spawn_area_max.x),
			spawn_area_min.y,  # Keep the Y position consistent (on the ground)
			randf_range(spawn_area_min.z, spawn_area_max.z)
		)
		
		finish_area.transform.origin = random_position
	else:
		print("Ground not found!")

func _on_body_entered(body: Node3D) -> void:
	if body == player:
		player_in_area = true
	elif body == victim:
		victim_in_area = true
	if player_in_area and victim_in_area:
		print("Mission successfully completed!")
		get_tree().quit()
	
func _on_body_exited(body: Node3D) -> void:
	if body == player:
		player_in_area = false
	elif body == victim:
		victim_in_area = false
