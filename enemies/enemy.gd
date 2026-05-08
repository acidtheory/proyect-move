extends CharacterBody3D

var gravity : float = 1

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity.y -= gravity

	move_and_slide()
