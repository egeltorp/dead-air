extends Node

signal incoming_started(freq, amp)
signal solved()
signal reset()
signal mode_changed(mode_freq: bool)

var waitTime: float = 5.0

var incoming_freq: float = 0.0
var incoming_amp: float = 0.0

var player_freq: float = 10.0
var player_amp: float = 16.0

var mode_freq := true

var is_standby := true

@export var freq_tolerance := 2
@export var amp_tolerance := 2


func standby():
	is_standby = true
	incoming_freq = 0.0
	incoming_amp = 0.0
	player_freq = 0.0
	player_amp = 0.0
	emit_signal("reset")


func start_incoming(freq: float, amp: float):
	is_standby = false
	incoming_freq = freq
	incoming_amp = amp
	player_freq = 10.0
	player_amp = 16.0
	emit_signal("incoming_started", freq, amp)


func update_player_tuning(delta):
	if is_standby:
		return
	
	var change_speed = 10
	
	print(str(player_freq))
	print(str(player_amp))

	if mode_freq:
		if Input.is_action_pressed("tune_up"):
			player_freq += change_speed * delta
		if Input.is_action_pressed("tune_down"):
			player_freq -= change_speed * delta
	else:
		if Input.is_action_pressed("tune_up"):
			player_amp += 20 * delta
		if Input.is_action_pressed("tune_down"):
			player_amp -= 20 * delta

	player_freq = clamp(player_freq, 2, 20.0)
	player_amp = clamp(player_amp, 0.0, 49.0)

	_check_match()


func switch_mode():
	mode_freq = !mode_freq
	emit_signal("mode_changed", mode_freq)


func _check_match():
	if abs(player_freq - incoming_freq) <= freq_tolerance \
	and abs(player_amp - incoming_amp) <= amp_tolerance:
		emit_signal("solved")
		standby()
