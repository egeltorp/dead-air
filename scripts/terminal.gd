extends Interactable

@onready var terminal_camera = $"../MonitorCamera3D"

func interact(player):
	pass
	
func get_interact_text() -> String:
	if WaveformManager.is_standby:
		return "Standby Mode"
	if !WaveformManager.is_standby:
		return "Decode"
	return ""
	
