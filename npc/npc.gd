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
#@onready var spot_area = $SpotArea

# Npc vision has a pyramid format
@onready var vision = $Vision
var pyramid_points 
var new_pyramid_points
var max_pyramid_points = PackedVector3Array( 
	[Vector3(0, 0, 0), 
	Vector3(-30, -10, 50),
	Vector3(30, -10, 50),
	Vector3(-30, 30, 50),
	Vector3(30, 30, 50),] )

var test_shape

var t


func _ready():
	state_machine = animation_tree.get("parameters/playback")
	animation_tree.set("parameters/conditions/idle", true)
	pyramid_points = vision.get_shape().get_points()
	test_shape = ConvexPolygonShape3D.new()
	
func _physics_process(delta):
	vision_update(delta)
	print(pyramid_points[1])
	
	match state_machine.get_current_node():
		"pistol_idle":
			pass
		"pistol_point":
			visuals.look_at(player.global_position)
			await get_tree().create_timer(2).timeout
			if Input.is_anything_pressed():
				player.alive = false
	
	
#	animation_tree.set("parameters/conditions/point", _on_spot_area_body_entered())
#	animation_tree.set("parameters/conditions/idle", !_on_spot_area_body_entered())
	
	
	move_and_slide()

func vision_update(d):
	test_shape.set_points(max_pyramid_points)
	vision.set_shape(test_shape)
	
#	for i in range(5):
		
#	t = d * 0.8
#	pyramid_points.set(1, pyramid_points[1].lerp(max_pyramid_points[1], t))
#	pyramid_points.set(1, Vector3(10,20,30))

#func _is_target_spotted():
#	return global_position.distance_to(player.global_position) < SPOT_RANGE

#func _on_spot_area_body_entered(body):
##	state_machine.travel("pistol_point")
#	animation_tree.set("parameters/conditions/point", true)
