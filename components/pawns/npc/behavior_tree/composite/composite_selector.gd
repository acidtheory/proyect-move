@icon("res://assets/textures/icons/behavior_tree/selector.svg")
extends Composite
class_name CompositeSelector

func step() -> Result:
	var children = get_children()
	if random_order: children.shuffle()
	for child : BehaviorNode in children:
		var child_result = child.step()
		if child_result != Result.SUCCESS:
			continue
		return Result.SUCCESS
	return Result.FAILURE
