extends Node
class_name MovementManager

@onready var player : Player = get_parent()
@onready var spring : SpringArm3D = $"../SpringArm3D"
@onready var weapon_manager = $"../WeaponManager"
@onready var mesh : Node3D = $"../PlayerMesh"

@export var jump_impulse : float = 6
@export var walk_speed : float = 5
@export var run_speed : float = 8
@export_range(1,30) var slipperiness : float = 30

@export_group("Dash")
@export var dash_speed : float = 25.0
@export var dash_duration : float = 0.2
@export var dash_cooldown : float = 0.6

var _dash_cooldown_timer : float = 0.0
var _dash_direction : Vector3

#running
var is_running = false
var is_aiming = false
var trapped = false # no hice nada con esto todavia

#move smoothing
var expected_velocity : Vector3

func _physics_process(delta):
	if _dash_cooldown_timer > 0:
		_dash_cooldown_timer -= delta
	_process_dash_input()
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
	if is_dashing:
		expected_velocity = _dash_direction * dash_speed
		expected_velocity.y = player.velocity.y
		player.velocity = player.velocity.move_toward(expected_velocity, delta * slipperiness * player.velocity.distance_to(expected_velocity))
		return
	if weapon_manager.is_attacking:
		player.velocity = Vector3(0, player.velocity.y, 0)
		return
	var input_direction : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := Vector3(input_direction.x, 0, input_direction.y).rotated(Vector3(0, 1, 0), spring.rotation.y)
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

func _process_dash_input():
	# Si apreta Alt, no está atacando, no está ya dasheando y tiene el cooldown listo
	if Input.is_action_just_pressed("dash") and not is_dashing and not weapon_manager.is_attacking and _dash_cooldown_timer <= 0:
		perform_dash()
func perform_dash():
	is_dashing = true
	player.invulnerable = true
	var input_direction : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if input_direction != Vector2.ZERO:
		_dash_direction = Vector3(input_direction.x, 0, input_direction.y).rotated(Vector3(0, 1, 0), spring.rotation.y).normalized()
	else:
		_dash_direction = -mesh.global_transform.basis.z.normalized()
	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false
	player.invulnerable = false
	_dash_cooldown_timer = dash_cooldown

func get_speed():
	if is_running:
		return run_speed
	return walk_speed
