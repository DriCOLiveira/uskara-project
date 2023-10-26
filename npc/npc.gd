extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SPOT_RANGE = 5.0

var state_machine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var visuals = $Visuals
@onready var player = GameManager.player
@onready var animation_tree = $"Visuals/X Bot/AnimationTree"

func _ready():
	state_machine = animation_tree.get("parameters/playback")

func _physics_process(delta):
	
	match state_machine.get_current_node():
		"pistol_idle":
			pass
		"pistol_point":
			visuals.look_at(player.global_position)
	
	animation_tree.set("parameters/conditions/point", _is_target_spotted())
	animation_tree.set("parameters/conditions/idle", !_is_target_spotted())
	
	
	move_and_slide()

func _is_target_spotted():
	return global_position.distance_to(player.global_position) < SPOT_RANGE
