extends Node3D

@onready var red_light = $red_light
@onready var green_light = $green_light

func _ready() -> void:
	WaveformManager.solved.connect(_on_solved)
	GameManager.sound_over.connect(_sound_over)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if WaveformManager.is_standby:
		red_light.visible = false
	if !WaveformManager.is_standby:
		red_light.visible = true
		

func _on_solved():
	green_light.visible = true
	

func _sound_over():
	green_light.visible = false
