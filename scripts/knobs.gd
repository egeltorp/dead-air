extends Node3D

@onready var LK := $L_Knob
@onready var RK := $R_Knob

@export var spin_speed: float = 0.1

func _process(delta: float) -> void:
	if !GameState.using_terminal:
		return
	if WaveformManager.mode_freq:
		if Input.is_action_pressed("tune_up"):
			LK.rotation.y += 1 * spin_speed
		if Input.is_action_pressed("tune_down"):
			LK.rotation.y += -1 * spin_speed
	else:
		if Input.is_action_pressed("tune_up"):
			RK.rotation.y += 1 * spin_speed
		if Input.is_action_pressed("tune_down"):
			RK.rotation.y += -1 * spin_speed
