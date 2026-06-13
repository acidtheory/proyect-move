extends Leaf
class_name LeafPickupAxe

@export var pickup_range: float = 1.2
@export var pickup_delay: float = 1.0

var _timer: float = -1.0

func step() -> Result:
	var npc: AxeEnemy = owner
	if npc.axe_count > 0:
		return Result.FAILURE

	var axe_detector = npc.get_node("AxeDetection") as Area3D
	var closest_axe = null
	var closest_dist = INF
	for body in axe_detector.get_overlapping_bodies():
		if body is RigidBody3D and body.is_in_group("axe"):
			var dist = npc.global_position.distance_to(body.global_position)
			if dist < closest_dist:
				closest_dist = dist
				closest_axe = body

	if not closest_axe:
		return Result.FAILURE

	if closest_dist > pickup_range:
		_timer = -1.0
		npc.nav.target_position = closest_axe.global_position
		var dir = npc.global_position.direction_to(npc.nav.get_next_path_position())
		npc.velocity = Vector3(dir.x * npc.speed, npc.velocity.y, dir.z * npc.speed)
		var look_target = Vector3(closest_axe.global_position.x, npc.global_position.y, closest_axe.global_position.z)
		npc.look_at(look_target)
		npc.rotation.y += PI
		return Result.RUNNING

	npc.velocity.x = 0
	npc.velocity.z = 0
	if _timer < 0:
		_timer = pickup_delay
	_timer -= get_physics_process_delta_time()
	if _timer <= 0:
		closest_axe.queue_free()
		npc.axe_count += 1
		return Result.SUCCESS

	return Result.RUNNING
