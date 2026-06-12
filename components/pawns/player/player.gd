extends Pawn
class_name Player

@export var anim : AnimationPlayer

@onready var movement = $Movement
@onready var camera = $Camera
@onready var weapon_manager = $WeaponManager


func _ready():
	Globals.player = self
