extends CharacterBody3D

const SPEED = 1.8
const JUMP_VELOCITY = 4.5

@onready var camera_point = $CameraPoint

var alive = true

var state_machine

var enemy
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var animation_player = $"Visuals/X Bot/AnimationPlayer"
@onready var animation_tree = $"Visuals/X Bot/AnimationTree"

@onready var visuals = $Visuals

func _ready():
	GameManager.set_player(self)
	state_machine = animation_tree.get("parameters/playback")
	animation_tree.set("parameters/conditions/idle", true)
	
func _physics_process(delta):
	#Alive Start--------------------------------------------------------------#
	if alive:
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		if Input.is_action_just_pressed("attack") and enemy:
			state_machine.travel("mma_kick")
			visuals.look_at(enemy.global_position)
			enemy.visuals.look_at(position)
			enemy.visuals.rotate_y(PI)
			await get_tree().create_timer(0.4).timeout
			enemy.state_machine.travel("death_from_the_back")

		# Get the input direction and handle the movement/deceleration.
		var walking = !(velocity.x == 0 and velocity.z == 0)
		var input_dir = Input.get_vector("left", "right", "foward", "backward")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			
			visuals.look_at(direction + position)
			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		animation_tree.set("parameters/conditions/idle", !walking)
		animation_tree.set("parameters/conditions/walk", walking)
		
		move_and_slide()
	#Alive End----------------------------------------------------------------#
	else:
		state_machine.travel("death")

func _on_attack_area_body_entered(body):
	enemy = body

