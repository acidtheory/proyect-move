extends Pawn
class_name Player

@export var anim : AnimationPlayer

@onready var movement = $Movement
@onready var camera = $Camera
@onready var weapon_manager = $WeaponManager
@onready var life_bar = $CanvasLayer/MarginContainer/ProgressBar

var axe_amount : int = 3

func _ready():
	Globals.player = self
	life_bar.max_value = 100
	life_bar.value = health
	
func _process(delta: float) -> void:
	life_bar.value = health
