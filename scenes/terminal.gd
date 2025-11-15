extends Node3D

@onready var terminal_camera = $"../MonitorCamera3D"
@onready var prompt = $"../Label"

func _ready() -> void:
	prompt.visible = false

func show_prompt():
	prompt.show()
	
func hide_prompt():
	prompt.visible = false
