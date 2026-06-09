@icon("res://assets/icons/sequence.svg")
extends BehaviorNode
class_name CompositorSequencer

func step() -> Result:
	for child : BehaviorNode in get_children():
		var child_result : Result = child.step()
		if child_result != Result.SUCCESS:
			return child_result
	return Result.SUCCESS
	
