extends "res://scripts/waveform_drawer.gd"

func _process(delta):
	freq = WaveformManager.player_freq
	amp = WaveformManager.player_amp
	phase += delta * freq * 2.0 * PI * 0.2
	queue_redraw()
