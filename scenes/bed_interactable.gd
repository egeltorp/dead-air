extends Interactable

func interact(player):
	if GameState.can_sleep:
		GameManager.player_slept()
		print("Player slept")
		WaveformManager.standby()
		GameState.can_sleep = false
func get_interact_text() -> String: 
	print("Sleep")
	return "Sleep"
	
