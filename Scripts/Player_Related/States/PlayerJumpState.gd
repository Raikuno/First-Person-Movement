extends State_Interface

func onEntered():
	if (!assigned_object is MainCharacter): 
		print("ERROR. THE OBJECT RELATED TO THE PLAYER STATE MACHINE IS NOT A PLAYER")
		get_tree().quit(-69)
	assigned_object.velocity.y = assigned_object.JUMPSTRENGTH
	assigned_object.velocity.x = assigned_object.stored_speed.x
	assigned_object.velocity.z = assigned_object.stored_speed.z

func onExited():
	assigned_object.stored_speed = assigned_object.velocity
	assigned_object.was_on_ground = false

func physics(delta:float):
	airMovement()
	toIdle()
	toWalk()
	toFall()
	assigned_object.move_and_slide()

func airMovement():
	var inp_direction: Vector2
	var direction: Vector3
	var relativeBasis:Basis
	var tween = get_tree().create_tween()
	inp_direction = Input.get_vector("Left", "Right", "Forward", "Backwards")
	relativeBasis = assigned_object.neck.transform.basis 
	direction = (relativeBasis * Vector3(inp_direction.x,0,inp_direction.y)).normalized()
	
	if(direction):
		if(abs(assigned_object.velocity.x + (direction.x * assigned_object.ACCELERATION)) < abs(assigned_object.SPEED * direction.x)):
			assigned_object.velocity.x += direction.x * assigned_object.ACCELERATION
		if(abs(assigned_object.velocity.z + (direction.z * assigned_object.ACCELERATION)) < abs(assigned_object.SPEED * direction.z)):
			assigned_object.velocity.z += direction.z * assigned_object.ACCELERATION
		tween.tween_property(assigned_object.neck.tilt, "rotation", Vector3(0,0,deg_to_rad(assigned_object.tilt_value*inp_direction.x)), 0.2)
	else:
		tween.tween_property(assigned_object.neck.tilt, "rotation", Vector3(0,0,0), 0.2)

func toIdle():
	if (assigned_object.velocity.x == 0
	&& assigned_object.velocity.y == 0
	&& assigned_object.is_on_floor()):
		state_swap.emit(name, "Idle")

func toWalk():
	if (assigned_object.is_on_floor() 
	&& assigned_object.velocity.y <= 0
	&& (assigned_object.velocity.x != 0
	|| assigned_object.velocity.z  != 0)):
		state_swap.emit(name, "Walk")

func toFall():
	if(assigned_object.velocity.y < 0):
		state_swap.emit(name, "Fall")
