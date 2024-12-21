extends CharacterBody3D

class_name Victim

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label = $Label3D
@onready var loading = $ColorRect
@onready var finish_area = $"../../FinishArea"
@onready var message = $"../../Message/Label"

@onready var nav_agent = $NavigationAgent3D


var player = null
var is_touching_player = false
var victim_is_free : bool = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var player_path : NodePath
@export var SPEED : float = 3.0
@export var DISTANCE_RANGE : float = 1.5

func _ready():
	player = get_node(player_path)
	animation_player.play("lay")

func _physics_process(delta):
	velocity = Vector3.ZERO
	label.visible = false

	if global_position.distance_to(player.global_position) < 1:
		is_touching_player = true
		label.visible = true
		if is_touching_player:
			#print("the victim touch you!")
			pass
	else:
		is_touching_player = false
		label.visible = false
		loading.visible = false
		if loading.value < 100:
			loading.value = 0
		
	if victim_is_free == true:
		
		message_for_victim()
		label.visible = false
		finish_area.visible = true
		
		await get_tree().create_timer(2.0).timeout  # Delay of 2 second
		path_finding()
		look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP)
		#if victim near around player
		if global_position.distance_to(player.global_position) < DISTANCE_RANGE:
			velocity = Vector3.ZERO 
			animation_player.play("idle")
		else:
			animation_player.play("run")
	
	# Add the gravity.
	if not is_on_floor():
		position.y -= gravity * delta

	move_and_slide()
	
func message_for_victim():
	message.text = "Bawa Ashley Ke Tempat Aman!"
	message.visible = true  # Menampilkan node messagevar text_label = message.get_node("text")  # Mengakses child node bernama "text"
	await get_tree().create_timer(5.0).timeout 
	message.visible = false  # Menyembunyikan node message setelah 1 detik
	
func path_finding():
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
