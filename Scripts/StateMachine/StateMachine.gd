extends Node

@export var assigned_object:CharacterBody3D
@export var initial_state : State_Interface
@export var debugText : DebugText
var current_state : State_Interface
var states: Dictionary

func _ready() -> void:
	for node : State_Interface in get_children():
		states[node.name.to_lower()] = node
		node.state_swap.connect(swap_state)
	
	initial_state.onEntered()
	current_state = initial_state

func _process(delta: float) -> void:
	current_state.process(delta)

func _physics_process(delta: float) -> void:
	debugText.debugPrint(current_state.name)
	current_state.physics(delta)

func swap_state(old:String, new:String) -> void:
	var old_state:State_Interface
	var new_state:State_Interface
	
	if((old.to_lower() in states.keys()) && (new.to_lower() in states.keys())):
		old_state = states[old.to_lower()]
		new_state = states[new.to_lower()]
	else:
		print("Error. State not recognized")
		return
	old_state.onExited()
	current_state = new_state
	current_state.onEntered()
