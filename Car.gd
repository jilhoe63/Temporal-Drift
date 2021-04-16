extends Spatial

onready var ball = $Ball
onready var car_mesh = $car_temporary
onready var ground_ray = $CarMesh/RayCast

export var sphere_offset = Vector3(0, -1, 0)
export var acceleration = 50
export var steering = 21.0
export var turn_speed = 5
export var turn_stop_limit = 0.75

export var speed_input = 0
export var rotate_input = 0

func _ready():
	ground_ray.add_exception(ball)
	
func _physics_process(_delta):
	car_mesh.transform.origin = ball.transform.origin + sphere_offset
	ball.add_central(-car_mesh.global_transform.basis.z * speed_input)

