extends AnimationTree
@onready var player : CharacterBody3D = get_parent()
var velocity_h : Vector3
var is_attacking : bool = false

func _physics_process(delta: float) -> void:
	velocity_h = Vector3(player.velocity.x, 0, player.velocity.z)
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
	else:
		is_attacking = false
