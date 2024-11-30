extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player = null

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var nav_agent = $NavigationAgent3D

@export var player_path : NodePath
@export var SPEED : float = 3.0

func _ready():
	player = get_node(player_path)
	
func _physics_process(delta):
	path_finding() #logic for pathfinding
	# Add the gravity.
	if not is_on_floor():
		position.y -= gravity * delta
		
	if not animation_player.is_playing():
		
		animation_player.play("mixamo_com")
	
	move_and_slide()
	
func path_finding():
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
