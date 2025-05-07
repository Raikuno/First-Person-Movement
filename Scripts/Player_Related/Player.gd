extends CharacterBody3D
class_name MainCharacter
@export var debugA:DebugText
@export var debugB:DebugText
@export var neck : Node3D
@export var ray_cast_pivot:RayManager
@export var SPEED = 50
@export var RUNNING_TIME_NEEDED = 2
@export var RUNNING_SPEED = 100
@export var RUNNING_RESISTANCE = 0.5
@export var JUMPSTRENGTH = 100
@export var JUMP_RESISTANCE_VALUE = 0.75
@export var ACCELERATION = 3
@export var tilt_value:float = 1
@export var coyote_time_value = 0.1
@onready var was_on_ground = false
var stored_speed : Vector3 = Vector3.ZERO
var target_speed : float = 0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	debugA.debugPrint(velocity.abs().length())
	debugB.debugPrint(Vector3(velocity.abs().x,0,velocity.abs().z).length())
	pass
