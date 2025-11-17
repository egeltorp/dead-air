extends Interactable

var toggle = true
@export var disabled: bool = true

func interact(player):
	toggle = !toggle
	volume()
	
func volume():
	if disabled:
		return
	if toggle:
		$"../..".volume_db = 0
	if !toggle:
		$"../..".volume_db = -80
		$"../../Lights/green_light".visible = false
