extends Node3D

@onready var player = Player
@onready var audio_player = $AudioStreamPlayer3D  # Referensi ke AudioStreamPlayer node

# Called when the node enters the scene tree for the first time.
func get_player() -> CharacterBody3D:
	var current_node = self
	while current_node != null:  # Traverse upwards until kita menemukan CharacterBody3D atau mencapai root
		if current_node is CharacterBody3D:
			return current_node
		current_node = current_node.get_parent()
	return null

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("skill") and visible:
		var player = get_player()  # Dapatkan instance player
		if player and player.has_method("increase_health"):
			player.increase_health(25.0)  # Tambah health pemain
			print("Medkit digunakan! Health pemain bertambah.")

			# Memutar suara
			if audio_player and not audio_player.playing:
				audio_player.play()
