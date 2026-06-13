extends Node
class_name MovementManager

@onready var player : Player = get_parent()
@onready var spring : SpringArm3D = $"../SpringArm3D"
@onready var weapon_manager = $"../WeaponManager"
@onready var mesh : Node3D = $"../PlayerMesh"

@export var jump_impulse : float = 10
@export var walk_speed : float = 10
@export var run_speed : float = 20
@export_range(1,30) var slipperiness : float = 30

#running
var is_running = false
var is_aiming = false
var trapped = false # no hice nada con esto todavia

#move smoothing
var expected_velocity : Vector3

func _physics_process(delta):
	_process_cosmetic(delta)
	_process_player_jump()
	_process_player_run(delta)
	_process_player_velocity(delta)
	player.move_and_slide()
	

func _process_player_jump():
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = jump_impulse
		player.anim.play("jump")

func _process_player_run(_delta : float):
	if Input.is_action_pressed("run"): is_running = true
	else: is_running = false
	if is_aiming:
		is_running = false
		return

func _process_player_velocity(delta : float):
	if weapon_manager.is_attacking:
		player.velocity = Vector3(0,player.velocity.y,0)
		return
	var input_direction : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := Vector3(input_direction.x,0,input_direction.y).rotated(Vector3(0,1,0),spring.rotation.y)
	expected_velocity = Vector3(direction.x * get_speed(), player.velocity.y, direction.z * get_speed())
	player.velocity = player.velocity.move_toward(expected_velocity, delta * slipperiness * player.velocity.distance_to(expected_velocity))

func _process_cosmetic(delta : float):
	mesh.global_rotation.y = lerp_angle(mesh.global_rotation.y, spring.global_rotation.y + PI, 9.0 * delta)
	
	if not weapon_manager.is_attacking and player.is_on_floor():
		if Vector2(player.velocity.x,player.velocity.z).length() > 0:
			if is_running: player.anim.play("Run")
			else: player.anim.play("Walk")
		else: player.anim.play("Idle")

# dash
var is_dashing : bool

func get_speed():
	if is_running:
		return run_speed
	return walk_speed
