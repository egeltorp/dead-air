extends Node

@onready var sound = $AudioStreamPlayer3D

func _ready():
	loop_sound()

func loop_sound() -> void:
	while true:
		if !WaveformManager.is_standby and !GameState.using_terminal:
			$AudioStreamPlayer3D.play()
			await $AudioStreamPlayer3D.finished
		else:
			await get_tree().create_timer(1).timeout
