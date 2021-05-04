extends Spatial

onready var ball = $Ball
onready var car_mesh = $car_temporary
onready var ground_ray = $CarMesh/RayCast
onready var right_wheel = #mesh for right wheel
onready var left_wheel = #mesh for left wheel
onready var body_mesh = #mesh for body

export var sphere_offset = Vector3(0, -1, 0)
export var acceleration = 50
export var steering = 21.0
export var turn_speed = 5
export var turn_stop_limit = 0.75
export var body_tilt = 35

export var speed_input = 0
export var rotate_input = 0

func _ready():
	ground_ray.add_exception(ball)
	
func _physics_process(_delta):
	car_mesh.transform.origin = ball.transform.origin + sphere_offset
	ball.add_central(-car_mesh.global_transform.basis.z * speed_input)

func _process(delta):
	if not ground_ray.is_colliding():
		return
	speed_input = 0
	speed_input += Input.get_action_strength("accelerate")
	speed_input -= Input.get_action_strength("brake")
	speed_input *= acceleration
	
	rotate_input = 0
	rotate_input += Input.get_action_strength("steer_left")
	rotate_input -= Input.get_action_strength("steer_right")
	rotate_input *= deg2rad(steering)
	
	right_wheel.rotation.y = rotate_input
	left_wheel.rotation.y = rotate_input
	
	if ball.linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y,rotate_input)
		car_mesh.global_transform = car_mesh.global_transform.basis.slerp(new_basis,turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
		
		var t = -rotate_input * ball.linear_velocity.length() / body_tilt
		body_mesh.rotation.z = lerp(body_mesh.rotation.z, t, 10 * delta)
		
	var n = ground_ray.get_collision_normal()
	var xform = align_with_y(car_mesh.global_transform, n.normalized)
	car_mesh.global_transform = car_mesh.global_transform.interpolate

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
		
