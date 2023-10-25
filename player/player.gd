extends CharacterBody3D


const SPEED = 1.8
const JUMP_VELOCITY = 4.5

@onready var camera_point = $CameraPoint

var state_machine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var animation_player = $"Visuals/X Bot/AnimationPlayer"
@onready var animation_tree = $"Visuals/X Bot/AnimationTree"

@onready var visuals = $Visuals

var walking = false

func _ready():
	GameManager.set_player(self)
	state_machine = animation_tree.get("parameters/playback")

func _physics_process(delta):
	
	match state_machine:
		"idle":
			pass
		"walk":
			pass
		"mma_kick":
			pass
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("attack"):
		state_machine.travel("mma_kick")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "foward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		visuals.look_at(direction + position)
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	
	animation_tree.set("parameters/conditions/idle", !_is_player_walking())
	animation_tree.set("parameters/conditions/walk", _is_player_walking())
	
	move_and_slide()

func _is_player_walking():
	return !(velocity.x == 0 and velocity.z == 0)
