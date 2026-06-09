extends Leaf
class_name LeafKillTarget

@export var is_target_player: bool = false
@export var target: Node3D
@export var damage: float = 10.0
@export var attack_cooldown: float = 1.0
@export var attack_range: float = 1.5

var _timer: float = 0.0

func step() -> Result:
	if not is_target_player:
		if not target:
			return Result.FAILURE
	else:
		target = Globals.player

	var dist = (owner as Enemy).global_position.distance_to(target.global_position)
	if dist > attack_range:
		return Result.FAILURE  # ← lejos: el Selector prueba el siguiente hijo

	_timer -= get_physics_process_delta_time()
	if _timer <= 0.0:
		target.take_damage(damage)
		_timer = attack_cooldown

	return Result.SUCCESS
