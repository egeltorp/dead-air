extends AudioStreamPlayer

@onready var yawn := $SleepLabel

func _process(delta: float) -> void:
	if GameState.can_sleep:
		yawn.visible = true
	if !GameState.can_sleep:
		yawn.visible = false
