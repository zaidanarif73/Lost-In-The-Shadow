extends CharacterBody3D

class_name Ghost

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player = null
var state_machine
# Ghost attack detection
var is_touching_player = false
var damage_timer : float = 0.0  # Timer to track when to deal damage
var walk_sound_timer : float = 0.0  # Timer for controlling walk sound playback

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree
@onready var walk_audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

@export var player_path : NodePath
@export var SPEED : float = 2.5
@export var ATTACK_RANGE : float = 1.0
@export var DAMAGE_INTERVAL : float = 1.0
@export var WALK_SOUND_INTERVAL : float = 2.0  # Interval between walk sounds

func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")
	
func _physics_process(delta):
	velocity = Vector3.ZERO
	match state_machine.get_current_node():
		"walk":
			path_finding() # Logic for pathfinding
			look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP)
			play_walk_sound(delta)  # Handle walk sound
		"attack":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
			# Check for collision with player
	if global_position.distance_to(player.global_position) < ATTACK_RANGE:
		is_touching_player = true
		
		if is_touching_player:
			damage_timer += delta  # Increase the timer by the elapsed time
			if damage_timer >= DAMAGE_INTERVAL:
				if player and player.health > 0:
					player.health -= 10  # Example: decrease health by 10
					player.health = max(0, player.health)  # Prevent health from going below 0
				damage_timer = 0.0  # Reset the timer after applying damage
	
	# Add the gravity.
	if not is_on_floor():
		position.y -= gravity * delta
		
	# Condition if get caught
	anim_tree.set("parameters/conditions/attack", target_in_range())
	anim_tree.set("parameters/conditions/walk", !target_in_range())
	
	move_and_slide()
	
func path_finding():
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
func target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func play_walk_sound(delta):
	# Increment the walk sound timer
	walk_sound_timer += delta
	
	# Check if the timer has exceeded the interval
	if walk_sound_timer >= WALK_SOUND_INTERVAL:
		if not walk_audio_player.playing:
			walk_audio_player.play()  # Play the walk sound
		walk_sound_timer = 0.0  # Reset the timer
