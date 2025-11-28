extends Node

@onready var incoming_player := $IncomingStatic
@onready var player_player   := $PlayerStatic

func _process(delta):
	var f_in = WaveformManager.incoming_freq
	var a_in = WaveformManager.incoming_amp

	var f_pl = WaveformManager.player_freq
	var a_pl = WaveformManager.player_amp

	var active = GameState.using_terminal and !WaveformManager.is_standby
	if active:
		if !incoming_player.playing: incoming_player.play()
		if !player_player.playing:   player_player.play()
	else:
		incoming_player.stop()
		player_player.stop()
		return

	# --- Incoming static modulation ---
	incoming_player.pitch_scale = clamp(
		f_in / max(f_pl, 0.001),
		0.2, 4.0
	)

	var incoming_db = linear_to_db(
		a_in / max(a_pl, 0.001)
	)
	incoming_player.volume_db = clamp(incoming_db, -30.0, 0.0)

	# --- Player static modulation ---
	player_player.pitch_scale = clamp(
		f_pl / max(f_in, 0.001),
		0.2, 4.0
	)

	var player_db = linear_to_db(
		a_pl / max(a_in, 0.001)
	)
	player_player.volume_db = clamp(player_db, -30.0, 0.0)
