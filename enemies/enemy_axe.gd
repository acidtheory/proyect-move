extends Enemy

func _physics_process(delta: float) -> void:
	$CompositorSequence/LeafFollowTarget.target = player
