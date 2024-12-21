extends CharacterBody3D

class_name Player

@export var SPEED : float = 5.0
@export var JUMP_VELOCITY : float = 4.5
@export var MOUSE_SENSITIVITY : float = 0.5
@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var CAMERA_CONTROLLER : Camera3D
@onready var JUMP_SFX = $JumpSfx
@onready var WALK_SFX = $WalkSfx

@onready var JUMP_BTN = $"../JumpBtn"
var _mouse_input : bool = false
var _rotation_input : float
var _tilt_input : float
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3

var health : float = 100.0 # Player's initial health
var max_health : float = 100.0 # Max health
@onready var health_bar : TextureProgressBar = $"../HealthBar/TextureProgressBar"
@onready var victim = $"../maps/Victim"
@onready var message = $"../Message/Label"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _unhandled_input(event: InputEvent) -> void:
	# Handle mouse movement input
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY

func _input(event: InputEvent) -> void:
	# Quit the game when "exit" is pressed
	if event.is_action_pressed("exit"):
		get_tree().quit()

	# Handle screen drag for mobile swipe
	if event is InputEventScreenDrag:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY

	# Stop rotation if the finger is lifted
	if event is InputEventScreenTouch and not event.pressed:
		_rotation_input = 0.0
		_tilt_input = 0.0

func _update_camera(delta: float) -> void:
	# Rotates camera using Euler rotation
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta

	_player_rotation = Vector3(0.0, _mouse_rotation.y, 0.0)
	_camera_rotation = Vector3(_mouse_rotation.x, 0.0, 0.0)

	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	global_transform.basis = Basis.from_euler(_player_rotation)

	CAMERA_CONTROLLER.rotation.z = 0.0

	_rotation_input = 0.0
	_tilt_input = 0.0

func _ready() -> void:
	# Capture mouse input for desktop
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Set the initial health on the health bar
	health_bar.value = health
	
	message.text = "Temukan Ashley! Dan Hindari Hantu"
	message.visible = true  # Menampilkan node messagevar text_label = message.get_node("text")  # Mengakses child node bernama "text"
	await get_tree().create_timer(5.0).timeout 
	message.visible = false  # Menyembunyikan node message setelah 1 detik

func _physics_process(delta: float) -> void:
	# Update camera movement based on input
	_update_camera(delta)

	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		JUMP_SFX.play()

	# Handle player movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		# Play walking sound if not already playing
		if not WALK_SFX.playing:
			WALK_SFX.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

		# Stop walking sound if character stops
		if WALK_SFX.playing:
			WALK_SFX.stop()

	move_and_slide()

	# Update health bar
	health_bar.value = health

	# Check for game over
	if health == 0:
		print("Bayangan gelap menyerang Anda. Game over.")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://scenes/lose_menu.tscn")

func increase_health(amount: float) -> void:
	# Increase health, ensuring it doesn't exceed max health
	health = clamp(health + amount, 0.0, max_health)
	print("Health increased. Current health: ", health)
