extends Area3D

@export var escape_presses: int = 8 
@export var slow_duration: float = 3.0

var _player_trapped: bool = false
var _press_count: int = 0

func _ready():
	body_entered.connect(_on_body_entered)

func _process(_delta):
	if not _player_trapped:
		return
		
	if Input.is_action_just_pressed("interact"):
		_press_count += 1
		if _press_count >= escape_presses:
			_escape()

func _on_body_entered(body):
	if body == Globals.player and not _player_trapped:
		_player_trapped = true
		_press_count = 0
		Globals.player.movement.trapped = true
		Globals.player.take_damage(15)
	elif body is NPC:
		body.take_damage(15, global_position)
		_trap_enemy(body)

func _trap_enemy(enemy: NPC):
	set_deferred("monitoring", false)
	visible = false
	enemy.hitstun_timer = 4.0 
	await get_tree().create_timer(4.0).timeout
	if is_instance_valid(enemy):
		var original_speed = enemy.move_speed
		enemy.move_speed = original_speed / 2.0
		
		await get_tree().create_timer(slow_duration).timeout
		if is_instance_valid(enemy):
			enemy.move_speed = original_speed
			
	queue_free()

func _escape():
	_player_trapped = false
	Globals.player.movement.trapped = false
	set_deferred("monitoring", false)
	visible = false
	var original_walk = Globals.player.movement.walk_speed
	var original_run = Globals.player.movement.run_speed

	Globals.player.movement.walk_speed = 4.0
	Globals.player.movement.run_speed = 6.0

	await get_tree().create_timer(slow_duration).timeout
	
	if is_instance_valid(Globals.player):
		Globals.player.movement.walk_speed = original_walk
		Globals.player.movement.run_speed = original_run

	queue_free()
