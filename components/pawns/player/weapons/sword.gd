extends Weapon
class_name SwordWeapon

@export var sword_area : Area3D

func attack():
	sword_area.connect("body_entered", _on_body_entered)
	if await play_interruptible_animation("Ataque1", 0.2):
		end()
	elif await play_interruptible_animation("Ataque2",0.2):
		end()
	elif await play_interruptible_animation("Ataque3",0.2):
		end()
	end()

func _on_body_entered(body : Node3D):
	if body is NPC:
		body.take_damage(30)

func end():
	sword_area.disconnect("body_entered", _on_body_entered)
