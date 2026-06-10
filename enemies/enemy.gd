extends CharacterBody3D

class_name Enemy

@export var speed = 2
@export var gravity : float = 10
@export var health = 100

@export var detection_range : float
@export var attack_range : float

var player : Node3D = null
var state: String = "idle" 
var override_look: bool = false

@onready var nav = $NavigationAgent3D as NavigationAgent3D
@onready var life_bar = $SubViewport/EnemyLifeBar


func _ready():
	life_bar.max_value = health
	life_bar.value = health
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	for child in get_children():
		if child is BehaviorNode:
			child.step()
	if player and not override_look:
		var look_target = Vector3(player.global_position.x, global_position.y, player.global_position.z)
		if global_position.distance_to(look_target) > 0.1:
			look_at(look_target)
			rotation_degrees.y += 180
	move_and_slide()

func _process(delta: float) -> void:
	life_bar.value = health

func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
