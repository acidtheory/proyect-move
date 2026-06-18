extends Leaf
class_name LeafPitchforkCharge

@export var min_charge_range: float = 2.5
@export var max_charge_range: float = 8.0
@export var charge_speed: float = 12.0
@export var damage: float = 50.0
@export var windup_time: float = 1.0
@export var vulnerability_time: float = 1.0

var _internal_state = "idle"
var _timer: float = 0.0
var _charge_dir: Vector3

func _ready():
	if owner is NPC:
		owner.took_damage.connect(_on_took_damage)

func _on_took_damage():
	_internal_state = "idle"
	if owner and "state" in owner:
		owner.state = "idle"

func step() -> Result:
	var npc : Enemy = owner
	var target = Globals.player
	if not target: return Result.FAILURE

	if npc.state != "idle" and npc.state != "charge_attack":
		return Result.FAILURE

	var dist = npc.global_position.distance_to(target.global_position)

	match _internal_state:
		"idle":
			if dist <= min_charge_range or dist > max_charge_range:
				return Result.FAILURE

			npc.state = "charge_attack"
			_internal_state = "windup"
			_timer = windup_time

		"windup":
			npc.override_look = false
			
			if _timer > windup_time / 2.0:
				var back_dir = npc.global_position.direction_to(target.global_position) * -1
				back_dir.y = 0
				back_dir = back_dir.normalized() * 2.5 
				npc.velocity.x = back_dir.x
				npc.velocity.z = back_dir.z
			else:
				npc.velocity.x = move_toward(npc.velocity.x, 0, get_physics_process_delta_time() * 20.0)
				npc.velocity.z = move_toward(npc.velocity.z, 0, get_physics_process_delta_time() * 20.0)

			_timer -= get_physics_process_delta_time()
			if _timer <= 0:
				_charge_dir = npc.global_position.direction_to(target.global_position)
				_charge_dir.y = 0
				_charge_dir = _charge_dir.normalized()
				_internal_state = "charging"
				_timer = 0.8 

		"charging":
			npc.override_look = true
			npc.velocity.x = _charge_dir.x * charge_speed
			npc.velocity.z = _charge_dir.z * charge_speed
			_timer -= get_physics_process_delta_time()

			if dist <= 1.5:
				target.take_damage(damage, npc.global_position)
				_internal_state = "vulnerable"
				_timer = vulnerability_time
				npc.velocity.x = 0
				npc.velocity.z = 0
			elif _timer <= 0:
				_internal_state = "vulnerable"
				_timer = vulnerability_time
				npc.velocity.x = 0
				npc.velocity.z = 0

		"vulnerable":
			npc.override_look = true
			npc.velocity.x = move_toward(npc.velocity.x, 0, get_physics_process_delta_time() * 20.0)
			npc.velocity.z = move_toward(npc.velocity.z, 0, get_physics_process_delta_time() * 20.0)

			_timer -= get_physics_process_delta_time()
			if _timer <= 0:
				_internal_state = "idle"
				npc.state = "idle" 
				npc.override_look = false
				return Result.SUCCESS

	return Result.RUNNING
