extends Pawn
class_name NPC

signal took_damage 

@onready var nav : NavigationAgent3D = $NavigationAgent3D
@export var move_speed : float = 3

var hitstun_timer : float = 0.0
var ai_enabled : bool = true 

func _physics_process(delta):
	super._physics_process(delta)
	
	if hitstun_timer > 0:
		hitstun_timer -= delta
		velocity.x = move_toward(velocity.x, 0, delta * 30.0)
		velocity.z = move_toward(velocity.z, 0, delta * 30.0)
	elif ai_enabled: # El cerebro del Behavior Tree solo piensa si está activado
		for child in get_children():
			if child is BehaviorNode:
				child.step()
				
	move_and_slide()

# Volvemos a los 2 argumentos limpios que tenías en tu Pawn base
func take_damage(damage: float, attacker_pos: Vector3 = Vector3.ZERO, knockback_mult: float = 1.0):
	super.take_damage(damage, attacker_pos, knockback_mult)
	hitstun_timer = 1
	took_damage.emit() 
	
	if attacker_pos != Vector3.ZERO:
		var knockback_dir = global_position.direction_to(attacker_pos) * -1
		knockback_dir.y = 0

		velocity = knockback_dir.normalized() * (4.0 * knockback_mult)
