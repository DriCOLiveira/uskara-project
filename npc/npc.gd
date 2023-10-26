extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
#const SPOT_RANGE = 5.0

var state_machine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var visuals = $Visuals
@onready var player = GameManager.player
@onready var animation_tree = $"Visuals/X Bot/AnimationTree"
@onready var spot_area = $SpotArea


func _ready():
	state_machine = animation_tree.get("parameters/playback")
	animation_tree.set("parameters/conditions/idle", true)

func _physics_process(delta):
	
	match state_machine.get_current_node():
		"pistol_idle":
			pass
		"pistol_point":
			visuals.look_at(player.global_position)
	
#	animation_tree.set("parameters/conditions/point", _on_spot_area_body_entered())
#	animation_tree.set("parameters/conditions/idle", !_on_spot_area_body_entered())
	
	
	move_and_slide()

#func _is_target_spotted():
#	return global_position.distance_to(player.global_position) < SPOT_RANGE

func _on_spot_area_body_entered(body):
#	state_machine.travel("pistol_point")
	animation_tree.set("parameters/conditions/point", true)
