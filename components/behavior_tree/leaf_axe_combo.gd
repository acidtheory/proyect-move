extends Leaf
class_name LeafAxeCombo

@export var attack_range: float = 1.5
@export var damage: float = 25.0
@export var time_between_hits: float = 0.5
@export var vulnerability_time: float = 1.0

@export var knockback_multiplier: float = 0.4 

var _internal_state = "idle"
var _timer: float = 0.0
var _hit_count: int = 0

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

	if npc.state != "idle" and npc.state != "combo_attack":
		return Result.FAILURE

	var dist = npc.global_position.distance_to(target.global_position)

	match _internal_state:
		"idle":
			if dist > attack_range:
				return Result.FAILURE

			npc.state = "combo_attack"
			_internal_state = "striking"
			_hit_count = 0
			_timer = 0.2 
			npc.velocity.x = 0
			npc.velocity.z = 0

		"striking":
			npc.velocity.x = 0
			npc.velocity.z = 0
			_timer -= get_physics_process_delta_time()

			if _timer <= 0:
				if dist <= attack_range:
					target.take_damage(damage, npc.global_position, knockback_multiplier)
				_hit_count += 1
				if _hit_count >= 3:
					_internal_state = "vulnerable"
					_timer = vulnerability_time
				else:
					_timer = time_between_hits

		"vulnerable":
			npc.velocity.x = 0
			npc.velocity.z = 0
			_timer -= get_physics_process_delta_time()

			if _timer <= 0:
				_internal_state = "idle"
				npc.state = "idle"
				return Result.SUCCESS

	return Result.RUNNING
