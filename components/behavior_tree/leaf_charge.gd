extends Leaf
class_name LeafCharge

@export var charge_range: float = 6.0
@export var windup_time: float = 1   # congela antes de cargar
@export var recovery_time: float = 2 # congela después de cargar
@export var charge_speed: float = 12.0

enum State { IDLE, WINDUP, CHARGING, RECOVERY }
var _state: State = State.IDLE
var _timer: float = 0.0
var _charge_dir: Vector3

func step() -> Result:
	var npc: PitchforkEnemy = owner
	var dist = npc.global_position.distance_to(Globals.player.global_position)

	match _state:
		State.IDLE:
			npc.override_look = false
			if dist > charge_range:
				return Result.FAILURE
			_state = State.WINDUP
			_timer = windup_time
			npc.velocity.x = 0
			npc.velocity.z = 0

		State.WINDUP:
			npc.override_look = false
			npc.velocity.x = 0
			npc.velocity.z = 0
			_timer -= get_physics_process_delta_time()
			if _timer <= 0:
				_charge_dir = npc.global_position.direction_to(Globals.player.global_position)
				_state = State.CHARGING

		State.CHARGING:
			npc.override_look = true
			npc.velocity = Vector3(_charge_dir.x * charge_speed, npc.velocity.y, _charge_dir.z * charge_speed)
			if dist < 1.0 or dist > charge_range * 1.5:
				_state = State.RECOVERY
				_timer = recovery_time
				npc.velocity.x = 0
				npc.velocity.z = 0

		State.RECOVERY:
			npc.override_look = true
			npc.velocity.x = 0
			npc.velocity.z = 0
			_timer -= get_physics_process_delta_time()
			if _timer <= 0:
				_state = State.IDLE
				return Result.SUCCESS

	return Result.WAIT
