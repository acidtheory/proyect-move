extends CharacterBody3D

@onready var _camera := %Camera3D as Camera3D
@onready var _camera_pivot := %CameraPivot as Node3D
@onready var _spring_arm := %SpringArm3D as SpringArm3D
@export var mesh : Node3D
@export_range(0.1, 3.0) var mouse_sensitivity : float = 1.8
@export var current_mouse_sensitivity : float
@export var aim_sensitivity : float = mouse_sensitivity/3
@export var camera_weight : float = 11
var tilt_limit = deg_to_rad(75)
var expected_rotation : Vector3 = Vector3(0, 0, 0)
var expected_velocity : Vector3 = Vector3(0, 0, 0)
@export var default_length : float = 3
@export var aim_length : float = 2.3
@export var default_fov : float = 60
@export var aim_fov : float = 30

@export var speed = 5.0
@export var velocity_weight : float = 10
@export var jump_velocity = 15
@export var gravity: float = 1


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	#soft movement
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	if Input.is_action_pressed("run") and Input.is_action_pressed("move_forward") and not Input.is_action_pressed("aim"):
		speed = 9
	else:
		speed = 5
	if Input.is_action_pressed("aim"):
		_spring_arm.spring_length = move_toward(_spring_arm.spring_length, aim_length, 0.15)
		_camera.fov = move_toward(_camera.fov, aim_fov, 2.5)
		current_mouse_sensitivity = aim_sensitivity
	else:
		_spring_arm.spring_length = move_toward(_spring_arm.spring_length, default_length, 0.15)
		_camera.fov = move_toward(_camera.fov, default_fov, 2.5)
		current_mouse_sensitivity = mouse_sensitivity
	var input_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := Vector3(input_direction.x,0,input_direction.y).rotated(Vector3(0,1,0),_camera_pivot.rotation.y)
	_camera_pivot.rotation = _camera_pivot.rotation.move_toward(expected_rotation,delta * camera_weight * _camera_pivot.rotation.distance_to(expected_rotation))
	if not is_on_floor():
		velocity.y -= gravity
	expected_velocity.x = direction.x * speed
	expected_velocity.z = direction.z * speed
	expected_velocity.y = velocity.y
	velocity = velocity.move_toward(expected_velocity, delta * velocity_weight * velocity.distance_to(expected_velocity))
	#mesh orientation
	mesh.global_rotation.y = lerp_angle(mesh.global_rotation.y, _camera.global_rotation.y + PI, 0.15)
	mesh.global_rotation.z = lerp_angle(mesh.global_rotation.z, _camera.global_rotation.z, 0.15)
	move_and_slide()
#camera weight
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		expected_rotation.x -= event.screen_relative.y * current_mouse_sensitivity * 0.001
		expected_rotation.x = clampf(expected_rotation.x, -tilt_limit, tilt_limit)
		expected_rotation.y += -event.screen_relative.x * current_mouse_sensitivity * 0.001
