extends RigidBody3D

@onready var pickup_area = $PickupHitbox

func _physics_process(delta):
	for body in pickup_area.get_overlapping_bodies():
		if body is CharacterBody3D and body == Globals.player:
			if Input.is_action_just_pressed("interact"): 
				pickup()

func pickup():
	Globals.scrap_amount += 1
	queue_free()
