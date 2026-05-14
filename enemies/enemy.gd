extends CharacterBody3D

class_name enemy

@export var speed = 2
@export var gravity : float = 1
@export var health = 100
@onready var life_bar = $SubViewport/EnemyLifeBar

var player : Node3D = null

func _ready():
	life_bar.max_value = health
	life_bar.value = health
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
		
func _physics_process(delta: float) -> void:
	
	if player:
		var direction = (player.global_position - global_position).normalized()
		var distance = global_position.distance_to(player.global_position)
		if distance > 2.0:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			var look_target = Vector3(player.global_position.x, global_position.y, player.global_position.z)
			if global_position.distance_to(look_target) > 0.1:
				look_at(look_target, Vector3.UP)
				rotate_object_local(Vector3.UP, PI)
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
	
	if not is_on_floor():
		velocity.y -= gravity

	move_and_slide()

func _process(delta: float) -> void:
	life_bar.value = health
	
func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
