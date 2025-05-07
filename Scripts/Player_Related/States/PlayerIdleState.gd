extends State_Interface

func onEntered():
	if (!assigned_object is MainCharacter): 
		print("ERROR. THE OBJECT RELATED TO THE PLAYER STATE MACHINE IS NOT A PLAYER")
		get_tree().quit(-69)

func physics(delta:float) -> void:
	toWalk()
	toJump()
	toFall()

func toWalk() -> void:
	if (Input.is_action_pressed("Right") 
	|| Input.is_action_pressed("Left")
	|| Input.is_action_just_pressed("Forward")
	|| Input.is_action_pressed("Backwards")):
		state_swap.emit(name, "Walk")

func onExited():
	assigned_object.stored_speed = Vector3.ZERO
	assigned_object.was_on_ground = true

func toJump() -> void:
	if(Input.is_action_pressed("Jump")):
		state_swap.emit(name, "Jump")

func toFall() -> void:
	if(!assigned_object.is_on_floor()):
		state_swap.emit(name, "Fall")
