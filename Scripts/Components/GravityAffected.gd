extends Node
class_name GravityAffected
@export var assigned_object: CharacterBody3D
@export var scalated : bool = true
@export var maxGravity = 0
func _physics_process(delta: float) -> void:
	if ((not assigned_object.is_on_floor()) ):
		print(assigned_object.velocity.y)
		assigned_object.velocity += assigned_object.get_gravity()
