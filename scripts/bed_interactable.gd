extends Interactable

func interact(player):
	if GameState.can_sleep:
		if GameManager.day == 4:
			$"../CeilingLight".visible = false
		# Sleep 'animation'
		$ColorRect.visible = true
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
		
		await get_tree().create_timer(3).timeout
		
		# Reset
		reset_player_after_sleep($"../../Player")
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
		$ColorRect.visible = false
		GameManager.player_slept()
		print("Player slept")
		WaveformManager.standby()
		GameState.can_sleep = false

func get_interact_text() -> String: 
	if GameState.can_sleep:
		return "Sleep"
	else:
		return "Not sleepy"
		
func reset_player_after_sleep(player):
	player.global_transform = GameState.start_transform
	player.player_camera.global_transform = GameState.start_camera_transform
