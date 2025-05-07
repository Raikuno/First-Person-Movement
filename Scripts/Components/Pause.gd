extends Node

@onready var paused: bool = false
@export var reanudar_butt: Button
@export var reiniciar_butt: Button
@export var salir_butt: Button
func pause():
	if(paused):
		paused = false
		get_tree().paused = paused
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		reanudar_butt.visible = false
		reiniciar_butt.visible = false
		salir_butt.visible = false
	else:
		paused = true
		get_tree().paused = paused
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		reanudar_butt.visible = true
		reiniciar_butt.visible = true
		salir_butt.visible = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Exit"):
		pause()

func reanudar():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	paused = false
	get_tree().paused = paused
	reanudar_butt.visible = false
	reiniciar_butt.visible = false
	salir_butt.visible = false

func reiniciar():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Stages/MainStage.tscn")

func exit():
	get_tree().quit(0)
