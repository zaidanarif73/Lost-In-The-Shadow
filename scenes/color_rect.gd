extends ColorRect

@export var value := 0.0
@export var max_value := 100.0
@export var min_value := 0.0

var success : bool = false
var SPEED = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_value(value)

func set_value(new_value : float):
	value = clamp(new_value, min_value, max_value)
	material.set_shader_parameter("value", value / (max_value - min_value))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.visible == true:
		set_value(value + SPEED)
		if value >= 100:
			success = true
			self.visible = false
