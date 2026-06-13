extends Decorator
class_name DecoratorInverter

func step() -> Result:
	var child = get_child(0) as BehaviorNode
	var result = child.step()
	if result == Result.RUNNING: return Result.RUNNING
	if result == Result.FAILURE: return Result.SUCCESS
	return Result.FAILURE
	
