extends Leaf
class_name LeafKillTarget

@export var is_target_player : bool = false
@export var target : Node3D

func step() -> Result:
	if not is_target_player:
		if not target:
			return Result.FAILURE
	else:
		target = Globals.player
	target.queue_free()
	return Result.SUCCESS
