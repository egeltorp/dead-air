extends Control

@onready var mode = $Label

func _ready():
	WaveformManager.mode_changed.connect(_on_mode_changed)
	_on_mode_changed(WaveformManager.mode_freq)
	WaveformManager.solved.connect(_on_solved)
	WaveformManager.reset.connect(_on_reset)
	
func _on_mode_changed(mode_freq: bool):
	if mode_freq:
		mode.text = "[SPACE] MODE: FREQUENCY"
	else:
		mode.text = "[SPACE] MODE: AMPLITUDE"
		
func _on_solved():
	pass
	
func _on_reset():
	pass
