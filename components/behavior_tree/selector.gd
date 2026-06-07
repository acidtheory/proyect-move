@icon("res://assets/icons/selector.svg")
extends BehaviorNode
class_name CompositorSelector

func step() -> Result:
	for child : BehaviorNode in get_children():
		var child_result : Result = child.step()
		if child_result != Result.FAILURE:
			return child_result
	return Result.FAILURE
	
