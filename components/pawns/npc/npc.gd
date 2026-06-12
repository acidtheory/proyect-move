extends Pawn
class_name NPC

@onready var nav : NavigationAgent3D = NavigationAgent3D.new()

@export var move_speed : float = 3

func _ready():
	var new_nav = get_node_or_null("NavigationAgent3D")
	if new_nav:
		nav.queue_free()
		nav = new_nav
	add_child(nav)

func _physics_process(delta):
	super._physics_process(delta)
	
	for child in get_children():
		if child is BehaviorNode:
			child.step()
	
	move_and_slide()
