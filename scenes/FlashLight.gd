extends Node3D

@onready var spotlight = get_node("Glass/SpotLight3D")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("skill"):
		spotlight.visible = !spotlight.visible
