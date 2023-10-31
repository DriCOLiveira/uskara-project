extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
#const VISION_INCREASE_RATE = Vector3(1, 1, 1)
#const SPOT_RANGE = 5.0

var state_machine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var visuals = $Visuals
@onready var player = GameManager.player
@onready var animation_tree = $"Visuals/X Bot/AnimationTree"
@onready var spot_area = $HeadCompartment/SpotArea
@onready var ray = $HeadCompartment/RayCast3D


var someone_there = false
# Npc vision has a pyramid format
#@onready var vision = $Vision


func _ready():
	state_machine = animation_tree.get("parameters/playback")
	animation_tree.set("parameters/conditions/idle", true)
	
func _physics_process(delta):
#	vision_update()
#	print(pyramid_points[1])
	
	match state_machine.get_current_node():
		"pistol_idle":
			pass
		"pistol_point":
			visuals.look_at(player.global_position)
			await get_tree().create_timer(2).timeout
			if Input.is_anything_pressed():
				player.alive = false
		"death":
			pass
	
#	animation_tree.set("parameters/conditions/point", _on_spot_area_body_entered())
#	animation_tree.set("parameters/conditions/idle", !_on_spot_area_body_entered())
	
	
	move_and_slide()


func _on_spot_area_body_entered(body):
	someone_there = true
	while someone_there:
		await get_tree().create_timer(0.01).timeout
		ray.look_at(player.global_position + Vector3(0, 1, 0))
		if ray.get_collider() == player:
			animation_tree.set("parameters/conditions/point", true)
		else:
			continue

func _on_spot_area_body_exited(body):
	someone_there = false
