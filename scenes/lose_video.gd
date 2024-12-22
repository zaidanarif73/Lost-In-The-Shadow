extends Node2D

@onready var video_player = $VideoStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Mengatur autoplay
	video_player.autoplay = true

	# Menambahkan callback untuk event selesai
	video_player.finished.connect(_on_video_finished)
	
# Callback ketika video selesai diputar
func _on_video_finished() -> void:
	change_scene_to_next_level()

func change_scene_to_next_level() -> void:
	# Pindah ke scene berikutnya
	get_tree().change_scene_to_file("res://scenes/lose_menu.tscn")
