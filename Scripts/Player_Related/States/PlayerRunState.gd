extends State_Interface
@export var debugA:DebugText
@export var debugB:DebugText

func onEntered():
	if (!assigned_object is MainCharacter): 
		print("ERROR. THE OBJECT RELATED TO THE PLAYER STATE MACHINE IS NOT A PLAYER")
		get_tree().quit(-69)

func physics(delta:float):
	movement()
	toWalk()
	assigned_object.move_and_slide()

func toWalk():
	if (assigned_object.is_on_wall() 
	|| (!Input.is_action_pressed("Forward")
	&& !Input.is_action_pressed("Backwards"))):
		state_swap.emit(name, "walk")

func onExited():
	assigned_object.stored_speed = assigned_object.velocity

func movement() -> void:
	var inp_direction: Vector2
	var direction: Vector3
	var relativeBasis:Basis
	
	inp_direction = Input.get_vector("Left", "Right", "Forward", "Backwards")
	relativeBasis = assigned_object.neck.transform.basis 
	
	direction = (relativeBasis * Vector3(inp_direction.x,0,inp_direction.y)).normalized()
	if(direction):
		assigned_object.velocity.x = direction.x * assigned_object.SPEED * assigned_object.RUNNING_RESISTANCE
		assigned_object.velocity.z = direction.z * assigned_object.RUNNING_SPEED
		debugA.debugPrint(assigned_object.velocity.x)
		debugB.debugPrint(assigned_object.velocity.z)
		assigned_object.neck.rotation.z = deg_to_rad(2*inp_direction.x)
	else:
		assigned_object.velocity.x = 0
		assigned_object.velocity.z = 0
		assigned_object.neck.rotation.z = 0
	
