extends Spatial

onready var ball = $Ball
onready var car_mesh = $CarMesh
onready var ground_ray = $CarMesh/RayCast
# mesh references.
onready var right_wheel = $CarMesh/tmpParent/auto/front_right
onready var left_wheel = $CarMesh/tmpParent/auto/front_left
onready var body_mesh = $CarMesh/tmpParent/auto/body


#Car characteristic variables.
export (bool) var show_debug = false
export var sphere_offset = Vector3(0, -1.0, 0)
export var acceleration = 62.5
export var steering = 21
export var turn_speed = 4
export var turn_stop_limit = 2
export var body_tilt = 200
export var speed_input = 0
export var rotate_input = 0
export var accelerating = false
var sound

func _ready():
	#Debug paraphernalia.
	$Ball/DebugMesh.visible = show_debug
	ground_ray.add_exception(ball)
	DebugOverlay.stats.add_property(ball, "linear_velocity", "length")
	DebugOverlay.draw.add_vector(ball, "linear_velocity", 1, 4, Color(0, 1, 0, 0.5))
	#DebugOverlay.draw.add_vector(car_mesh, "transform:basis:z", -4, 4, Color(1, 5, 0, 0.5))

func _process(delta):
	
	if Input.is_action_just_pressed("accelerate") and accelerating == false:
		accelerating = true
		sound = SoundPlayer.play_sound_effect("accelerate")
		
	elif Input.is_action_just_released("accelerate") and accelerating == true:
		accelerating = false
		sound.stop()
	
	#Making sure the car can't turn in the air.
	if not ground_ray.is_colliding():
		return
	speed_input = 0
	speed_input += Input.get_action_strength("accelerate")
	speed_input -= Input.get_action_strength("brake") 
	speed_input *= acceleration
	#rotate_target = lerp(rotate_target, rotate_input, 5 * delta)
	rotate_input = 0
	rotate_input += Input.get_action_strength("steer_left")
	rotate_input -= Input.get_action_strength("steer_right")
	rotate_input *= deg2rad(steering)
	
	#This turns the wheels.
	right_wheel.rotation.y = rotate_input * 0.6
	left_wheel.rotation.y = rotate_input * 0.6

	# This makes the wheels smoke.
	var d = ball.linear_velocity.normalized().dot(-car_mesh.transform.basis.y)
	if ball.linear_velocity.length() > 0 and d < -10:
		$CarMesh/Smoke.emitting = true
		$CarMesh/Smoke2.emitting = true
	else:
		$CarMesh/Smoke.emitting = false
		$CarMesh/Smoke2.emitting = false
		
	#This turns the car.
	if ball.linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y, rotate_input)
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
		
		#This squats the car under acceleration a bit.
		var t = rotate_input * ball.linear_velocity.length() / body_tilt
		body_mesh.rotation.x = -lerp(body_mesh.rotation.z, t, 10 * delta)
		
	# align mesh with ground normal
	var n = ground_ray.get_collision_normal()
	var xform = align_with_y(car_mesh.global_transform, n.normalized())
	car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10 * delta)
	
func _physics_process(delta):
	#car_mesh.transform.origin = ball.transform.origin + sphere_offset
	# just lerp the y due to trimesh bouncing
	car_mesh.transform.origin.x = ball.transform.origin.x + sphere_offset.x
	car_mesh.transform.origin.z = ball.transform.origin.z + sphere_offset.z
	car_mesh.transform.origin.y = lerp(car_mesh.transform.origin.y, ball.transform.origin.y + sphere_offset.y, 10 * delta)
#	car_mesh.transform.origin = lerp(car_mesh.transform.origin, ball.transform.origin + sphere_offset, 0.3)
	ball.add_central_force(-car_mesh.global_transform.basis.z * speed_input)

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
