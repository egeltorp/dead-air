extends Interactable

func interact(player):
	$AudioStreamPlayer3D.play()
	
func get_interact_text() -> String: return "Locked Door"
