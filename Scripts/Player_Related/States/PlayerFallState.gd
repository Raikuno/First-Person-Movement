extends State_Interface

@onready var on_coyote_time = true
var coyote_timer:Timer
func onEntered():
	if (!assigned_object is MainCharacter): 
		print("ERROR. THE OBJECT RELATED TO THE PLAYER STATE MACHINE IS NOT A PLAYER")
		get_tree().quit(-69)
	assigned_object.velocity = assigned_object.stored_speed
	on_coyote_time = assigned_object.was_on_ground
	coyote_timer_start()
	

func coyote_timer_start():
	coyote_timer = Timer.new()
	coyote_timer.one_shot = true
	coyote_timer.autostart = true
	coyote_timer.wait_time = assigned_object.coyote_time_value
	coyote_timer.timeout.connect(coyote_func)
	coyote_timer.start()
	add_child(coyote_timer)

func coyote_func():
	on_coyote_time = false

func onExited():
	assigned_object.stored_speed = Vector3(assigned_object.velocity.x, 0, assigned_object.velocity.z)
	assigned_object.was_on_ground = false

func airMovement():
	var inp_direction: Vector2
	var direction: Vector3
	var relativeBasis:Basis
	var tween = get_tree().create_tween()
	inp_direction = Input.get_vector("Left", "Right", "Forward", "Backwards")
	
	if (!assigned_object is MainCharacter): 
		print("ERROR. THE OBJECT RELATED TO THE PLAYER STATE MACHINE IS NOT A PLAYER")
		return
	
	relativeBasis = assigned_object.neck.transform.basis 
	
	direction = (relativeBasis * Vector3(inp_direction.x,0,inp_direction.y)).normalized()
	if(direction):
		#debug delete later
		var total_spd = Vector3(assigned_object.velocity.abs().x, 0, assigned_object.velocity.abs().z).length()
		
		
		if(abs(assigned_object.velocity.x + (direction.x * assigned_object.ACCELERATION)) < abs(assigned_object.SPEED * direction.x)):
			assigned_object.velocity.x += direction.x * assigned_object.ACCELERATION
		
		if(abs(assigned_object.velocity.z + (direction.z * assigned_object.ACCELERATION)) < abs(assigned_object.SPEED * direction.z)):
			assigned_object.velocity.z += direction.z * assigned_object.ACCELERATION
		
		
		
		tween.tween_property(assigned_object.neck.tilt, "rotation", Vector3(0,0,deg_to_rad(assigned_object.tilt_value*inp_direction.x)), 0.2)
	else:
		tween.tween_property(assigned_object.neck.tilt, "rotation", Vector3(0,0,0), 0.2)

func physics(delta:float):
	airMovement()
	toIdle()
	toWalk()
	toJump()
	assigned_object.move_and_slide()

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

func toJump() -> void:
	if(Input.is_action_pressed("Jump") && on_coyote_time):
		state_swap.emit(name, "Jump")
