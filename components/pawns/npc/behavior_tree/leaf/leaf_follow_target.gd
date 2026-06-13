extends Leaf
class_name LeafFollowTarget

@export var target : Node3D
@export var target_desired_distance : float = 1

var last_position : Vector3 = Vector3.INF

func step() -> Result:
	if not owner is NPC or not target:
		#print("%s: Failure" % self)
		return Result.FAILURE
	owner = owner as NPC
	if owner.global_position.distance_to(target.global_position) <= target_desired_distance:
		#print("%s: Success" % self)
		owner.velocity.x = 0
		owner.velocity.z = 0
		return Result.SUCCESS
	owner.nav.target_position = target.global_position
	owner.nav.target_desired_distance = target_desired_distance
	var direction = owner.global_position.direction_to(owner.nav.get_next_path_position()) * owner.move_speed
	owner.velocity = Vector3(direction.x,owner.velocity.y,direction.z)
	#print("%s: Running" % self)
	return Result.RUNNING
