extends Area3D

@export var escape_presses: int = 8 
@export var slow_duration: float = 3.0
@export var slow_speed: float = 2.0

var _player_trapped: bool = false
var _press_count: int = 0

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
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
		Globals.player.trapped = true

func _escape():
	_player_trapped = false
	Globals.player.trapped = false
	Globals.player.speed = slow_speed
	queue_free()
	await get_tree().create_timer(slow_duration).timeout
	if is_instance_valid(Globals.player): 
		Globals.player.speed = 5.0
