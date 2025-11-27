extends Interactable

func interact(player):
	var asp = $AudioStreamPlayer3D
	if not asp.playing:
		asp.play()

func get_interact_text() -> String: return interact_text
