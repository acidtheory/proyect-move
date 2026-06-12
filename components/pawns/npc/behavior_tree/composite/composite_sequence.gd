@icon("res://assets/textures/icons/behavior_tree/sequence.svg")
extends Composite
class_name CompositeSequence

func step() -> Result:
	var children = get_children()
	if random_order: children.shuffle()
	for child : BehaviorNode in children:
		var child_result = child.step()
		if child_result != Result.SUCCESS:
			return child_result
	return Result.SUCCESS
