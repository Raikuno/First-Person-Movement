extends Node3D
class_name NeckCamera

@export var LIMIT_DEG = 50
@export var tilt : Node3D
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		rotation.y -= event.relative.x * Rodrigo.SENSIBILITY
		rotation.x -= event.relative.y * Rodrigo.SENSIBILITY
	rotation.x = clamp(rotation.x, deg_to_rad(-LIMIT_DEG), deg_to_rad(LIMIT_DEG))
	
