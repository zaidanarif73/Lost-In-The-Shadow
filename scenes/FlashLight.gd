extends Node3D

@onready var spotlight = get_node("Glass/SpotLight3D")
@onready var skill_audio_player = $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("skill") and visible:
		spotlight.visible = !spotlight.visible
		if not skill_audio_player.playing:  # Memastikan audio tidak bertumpuk
			skill_audio_player.play()  # Memutar suara
