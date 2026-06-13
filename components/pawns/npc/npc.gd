extends Pawn
class_name NPC

@onready var nav : NavigationAgent3D = $NavigationAgent3D

@export var move_speed : float = 3

func _physics_process(delta):
	super._physics_process(delta)
	
	for child in get_children():
		if child is BehaviorNode:
			child.step()
	
	move_and_slide()
