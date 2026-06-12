extends Node
class_name CameraManager

var expected_rotation : Vector3
var expected_length : float = 2
var expected_offset : Vector2 = Vector2(0,0)
@export var default_length : float = 2
@export var default_offset : Vector2 = Vector2(2,0)
@export_range(1,30) var slipperiness : float = 30
@onready var spring : SpringArm3D = $"../SpringArm3D"
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	expected_length = default_length
	expected_offset = default_offset

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		expected_rotation.x -= event.screen_relative.y * Settings.mouse_sens * 0.001
		expected_rotation.x = clampf(expected_rotation.x, -PI/2, PI/2)
		expected_rotation.y += -event.screen_relative.x * Settings.mouse_sens * 0.001
		
func _physics_process(delta):
	spring.rotation = spring.rotation.move_toward(expected_rotation,delta * slipperiness * spring.rotation.distance_to(expected_rotation))
	spring.spring_length = move_toward(spring.spring_length, expected_length, delta *  slipperiness * abs(spring.spring_length - expected_length))
	spring.get_child(0).h_offset = move_toward(spring.get_child(0).h_offset,expected_offset.x, delta * slipperiness * abs(spring.get_child(0).h_offset - expected_offset.x))
	spring.get_child(0).v_offset = move_toward(spring.get_child(0).v_offset,expected_offset.y, delta * slipperiness * abs(spring.get_child(0).v_offset - expected_offset.y))
