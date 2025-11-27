extends Node

@export var waveform_source: Node        # waveform node to read freq/amp/phase from

const SAMPLE_RATE := 44100.0
var playback: AudioStreamPlayback

var phase := 0.0

var current_amp := 0.0
var target_amp := 0.0

# low pass filter
var last_sample := 0.0
var filter_strength := 0.1  # lower = more smoothing

# audio player, for muting purposes
var player = null

func _ready():
	var gen := AudioStreamGenerator.new()
	gen.mix_rate = SAMPLE_RATE

	player = AudioStreamPlayer.new()
	add_child(player)

	player.stream = gen
	player.play()

	playback = player.get_stream_playback()

func _process(_delta):
	if playback == null or waveform_source == null:
		return
	if !GameState.using_terminal or WaveformManager.is_standby:
		player.volume_db = -80
	else:
		player.volume_db = 0
	_fill_buffer()

func _fill_buffer():
	var frames = playback.get_frames_available()
	if frames <= 0:
		return

	var freq = waveform_source.freq
	var amp = waveform_source.amp

	var amp_norm = clamp(amp / 50.0, 0.0, 1.0)

	for i in frames:
		# raw sine
		var raw = asin(sin(phase)) * (2.0 / PI)

		# low-pass
		last_sample = lerp(last_sample, raw, filter_strength)

		var sample = last_sample * amp_norm

		phase += (freq * 2.0 * PI) / SAMPLE_RATE

		playback.push_frame(Vector2(sample, sample))
