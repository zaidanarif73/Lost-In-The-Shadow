extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player = null
var state_machine

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree

@export var player_path : NodePath
@export var SPEED : float = 3.0
@export var ATTACK_RANGE : float = 0.8

func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")
	
func _physics_process(delta):
	velocity = Vector3.ZERO
	match state_machine.get_current_node():
		"walk":
			path_finding() #logic for pathfinding
			look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP)
		"attack":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	# Add the gravity.
	if not is_on_floor():
		position.y -= gravity * delta
		
	#condition if get caught
	anim_tree.set("parameters/conditions/attack", target_in_range())
	anim_tree.set("parameters/conditions/walk", !target_in_range())
	
	move_and_slide()
	
func path_finding():
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
func target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
