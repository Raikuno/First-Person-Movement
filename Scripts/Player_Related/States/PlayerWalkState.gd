extends State_Interface
var timer : Timer
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
	timer = Timer.new()
	timer.one_shot = true
	timer.autostart = true
	timer.wait_time = assigned_object.RUNNING_TIME_NEEDED
	timer.timeout.connect(toRun)
	timer.start()
	add_child(timer)
	

func onExited():
	assigned_object.stored_speed = Vector3(assigned_object.velocity.x, 0, assigned_object.velocity.z)
	assigned_object.was_on_ground = true
	timer.queue_free()

func toRun():
	#state_swap.emit(name, "Running")
	pass

func movement(delta) -> void:
	var inp_direction: Vector2
	var direction: Vector3
	var relativeBasis: Basis
	var total_spd: float
	var tween = get_tree().create_tween()
	
	inp_direction = Input.get_vector("Left", "Right", "Forward", "Backwards")
	relativeBasis = assigned_object.neck.transform.basis 
	
	direction = (relativeBasis * Vector3(inp_direction.x,0,inp_direction.y)).normalized()
	if(direction):
		total_spd = Vector3(assigned_object.velocity.abs().x, 0, assigned_object.velocity.abs().z).length()
		assigned_object.velocity.x = direction.x * assigned_object.SPEED
		assigned_object.velocity.z = direction.z * assigned_object.SPEED
		print(total_spd)
		#assigned_object.velocity.x = direction.x * assigned_object.SPEED
		#assigned_object.velocity.z = move_toward(assigned_object.velocity.z,direction.z * assigned_object.SPEED, 1)
		#assigned_object.neck.rotation.z = deg_to_rad(1*inp_direction.x)
		tween.tween_property(assigned_object.neck.tilt, "rotation", Vector3(0,0,deg_to_rad(assigned_object.tilt_value*inp_direction.x)), 0.2)
	else:
		assigned_object.velocity.x = 0
		assigned_object.velocity.z = 0
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
