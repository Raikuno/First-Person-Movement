extends CharacterBody3D
class_name MainCharacter
@export var debugA:DebugText
@export var debugB:DebugText
@export var neck : Node3D
@export var SPEED = 70
@export var RUNNING_TIME_NEEDED = 2
@export var RUNNING_SPEED = 100
@export var RUNNING_RESISTANCE = 0.75
@export var JUMPSTRENGTH = 250
@export var JUMP_RESISTANCE_VALUE = 0.5
@export var ACCELERATION = 10
@export var tilt_value:float = 1
@export var coyote_time_value = 0.5
@onready var was_on_ground = false
var stored_speed : Vector3 = Vector3.ZERO


func _physics_process(delta: float) -> void:
	debugA.debugPrint(velocity.abs().length())
	debugB.debugPrint(Vector3(velocity.abs().x,0,velocity.abs().z).length())
	
	pass
