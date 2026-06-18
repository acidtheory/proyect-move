extends NPC

class_name Enemy

@export var speed = 2
@export var gravity : float = 10

@export var detection_range : float
@export var attack_range : float

var player : Node3D = null
var state: String = "idle" 
var override_look: bool = false

@onready var life_bar = $SubViewport/EnemyLifeBar


func _ready():
	life_bar.max_value = health
	life_bar.value = health
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if player and not override_look and hitstun_timer <= 0:
		var look_target = Vector3(player.global_position.x, global_position.y, player.global_position.z)
		if global_position.distance_to(look_target) > 0.1:
			look_at(look_target)
			rotation_degrees.y += 180

func _process(delta: float) -> void:
	life_bar.value = health
