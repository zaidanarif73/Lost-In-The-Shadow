extends TextureProgressBar

@export var max_health: int = 100
var current_health: int = max_health
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_health()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_health():
	value = current_health
