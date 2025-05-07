extends State_Interface

func physics(delta: float):
	movement(delta)
	toJump()
	toIdle()
	toFall()
	assigned_object.move_and_slide()

func onEntered():
	if (!assigned_object is MainCharacter): 
		print("ERROR. THE OBJECT RELATED TO THE PLAYER STATE MACHINE IS NOT A PLAYER")
		get_tree().quit(-69)
	assigned_object.target_speed = assigned_object.stored_speed.length()

func onExited():
	assigned_object.target_speed = 0
	assigned_object.stored_speed = Vector3(assigned_object.velocity.x, 0, assigned_object.velocity.z)
	assigned_object.was_on_ground = true

func toRun():
	#state_swap.emit(name, "Running")
	pass

func movement(delta) -> void:
	var inp_direction: Vector2
	var direction: Vector3
	var relativeBasis: Basis
	var tween = get_tree().create_tween()
	inp_direction = Input.get_vector("Left", "Right", "Forward", "Backwards")
	relativeBasis = assigned_object.neck.transform.basis
	direction = (relativeBasis * Vector3(inp_direction.x,0,inp_direction.y)).normalized()
	
	if(direction):
		if(assigned_object.target_speed < assigned_object.SPEED):
			assigned_object.target_speed += assigned_object.ACCELERATION 
		elif(assigned_object.target_speed > assigned_object.SPEED):
			assigned_object.target_speed = assigned_object.SPEED
		slopyFix(Vector3(direction.x, 0, direction.z))
		assigned_object.velocity.x = direction.x * assigned_object.target_speed
		assigned_object.velocity.z = direction.z * assigned_object.target_speed
		#assigned_object.velocity.x = direction.x * assigned_object.SPEED
		#assigned_object.velocity.z = move_toward(assigned_object.velocity.z,direction.z * assigned_object.SPEED, 1)
		#assigned_object.neck.rotation.z = deg_to_rad(1*inp_direction.x)
		tween.tween_property(assigned_object.neck.tilt, "rotation", Vector3(0,0,deg_to_rad(assigned_object.tilt_value*inp_direction.x)), 0.2)
	else:
		assigned_object.velocity.x  = 0
		assigned_object.velocity.z  = 0
		tween.tween_property(assigned_object.neck.tilt, "rotation", Vector3(0,0,0), 0.2)

func toJump() -> void:
	if(Input.is_action_pressed("Jump") && assigned_object.is_on_floor()):
		state_swap.emit(name, "Jump")

func toIdle() -> void:
	if assigned_object.velocity == Vector3.ZERO:
		state_swap.emit(name, "Idle")

func toFall() -> void:
	if(!assigned_object.is_on_floor()):
		state_swap.emit(name, "Fall")

func slopyFix(next_position) -> void:
	var expected_y: float
	var pivot:RayManager
	var ray:RayCast3D
	pivot = assigned_object.ray_cast_pivot
	ray = assigned_object.ray_cast_pivot.vertical_ray
	
	pivot.position = Vector3(next_position.x, 0, next_position.z)
	if(ray.get_collision_point().y < assigned_object.position.y):
		expected_y = ray.get_collision_point().y
		assigned_object.position.y = expected_y
