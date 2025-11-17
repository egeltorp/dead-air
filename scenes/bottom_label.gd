extends Control

@onready var mode = $Label
@onready var solved = $"../Solved"

func _ready():
	WaveformManager.mode_changed.connect(_on_mode_changed)
	_on_mode_changed(WaveformManager.mode_freq)
	WaveformManager.solved.connect(_on_solved)
	WaveformManager.reset.connect(_on_reset)
	solved.visible = false
	
func _process(delta: float) -> void:
	if GameState.using_terminal:
		if Input.is_action_just_pressed("switch_mode"):
			$"../SFX/SwitchMode".play()
	
func _on_mode_changed(mode_freq: bool):
	if mode_freq:
		mode.text = "[SPACE] MODE: FREQUENCY"
	else:
		mode.text = "[SPACE] MODE: AMPLITUDE"
		
func _on_solved():
	$"../SFX/Solved".play()
	solved.visible = true
	
func _on_reset():
	solved.visible = false
