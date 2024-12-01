extends Node3D

@onready var key = $Key
@onready var senter = $Weapon
@onready var medkit = $Medkit

# Array of weapon types
var weapons = ["senter", "medkit", "key"]
var current_weapon_index = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	senter.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("change_weapon"):
		_change_weapon()

func _change_weapon() -> void:
	# Hide all weapons first
	senter.visible = false
	medkit.visible = false
	key.visible = false

	# Update current weapon index
	current_weapon_index = (current_weapon_index + 1) % weapons.size()
	# Show only the current weapon
	var current_weapon = weapons[current_weapon_index]
	if current_weapon == "senter":
		senter.visible = true
	elif current_weapon == "medkit":
		medkit.visible = true
	elif current_weapon == "key":
		key.visible = true
