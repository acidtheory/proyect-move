extends Leaf
class_name LeafThrowAxe

@export var throw_range: float = 8.0

func step() -> Result:
	var npc: AxeEnemy = owner
	if npc.axe_count <= 0:
		return Result.FAILURE
	var dist = npc.global_position.distance_to(Globals.player.global_position)
	if dist > throw_range:
		return Result.FAILURE
	npc.throw_axe()
	return Result.SUCCESS
