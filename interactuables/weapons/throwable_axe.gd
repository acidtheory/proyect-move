extends RigidBody3D

@onready var pickup_area = $PickupHitbox
@onready var hit_area = $Hitbox

var hitted : bool = false

func _physics_process(delta):
	for body in pickup_area.get_overlapping_bodies():
		if body is CharacterBody3D and body == Globals.player:
			if Input.is_action_just_pressed("interact"): 
				pickup()

func pickup():
	Globals.player.axe_amount += 1
	queue_free()


func _on_hitbox_body_entered(body: Node3D) -> void:
	print("hitbox tocó: ", body.name)
	if hitted:
		return
	if body is Enemy and linear_velocity.length() > 4.0:
		body.take_damage(7)
		hitted = true
