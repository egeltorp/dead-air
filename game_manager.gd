extends Node

signal day_started(day)
signal day_completed(day)
signal all_days_completed()
signal sound_over()

var day := 1
var signals_solved := 0
var player_slept_today := false

@onready var speaker := $"/root/Node3D/Speaker"

@onready var solve_sounds_1 := [
	"res://audio/signals/static.wav",
	"res://audio/signals/day1_signal2.wav",
	"res://audio/signals/day1_signal3.wav",
]
@onready var solve_sounds_2 := [
	"res://audio/signals/static.wav",
	"res://audio/signals/day2_signal2.wav",
	"res://audio/signals/static.wav",
]

@onready var day_sounds := [solve_sounds_1, solve_sounds_2]

var running := false


func _ready():
	GameState.can_sleep = false
	WaveformManager.solved.connect(_on_signal_solved)
	start_day()


func start_day():
	if day > 5:
		print("All days completed.")
		emit_signal("all_days_completed")
		return
	
	signals_solved = 0
	print("PHONE RINGS: Day ", day, " begins.")
	emit_signal("day_started", day)
	
	# simulate phone call
	await get_tree().create_timer(2.0).timeout
	
	# wait 10 seconds before first signal
	await get_tree().create_timer(10.0).timeout
	
	# begin the 3 incoming signals
	_run_signal_sequence()


func _run_signal_sequence():
	running = true
	for i in range(3):
		_send_incoming_signal(i)
		
		# Wait until user solves it
		await _wait_for_signal_solve()
		
		# Play the correct sound for this signal
		_play_solved_sound(i)
		
		# brief delay before next incoming signal
		print("Starting TIMER 30 SECONDS")
		await get_tree().create_timer(30).timeout
		print("TIMER DONE")
	
	running = false
	end_day()


func _send_incoming_signal(index: int):
	var freq = randf_range(2, 20)
	var amp = randf_range(20.0, 49)
	
	print("INCOMING SIGNAL #", index+1, " (Day ", day, ") Freq:", freq, " Amp:", amp)
	
	WaveformManager.start_incoming(freq, amp)


func _wait_for_signal_solve() -> void:
	while true:
		if signals_solved > 0:
			signals_solved -= 1
			return
		await get_tree().process_frame


func _play_solved_sound(index: int):
	var solve_sounds = day_sounds[day - 1]
	var audio_path = solve_sounds[index]
	
	var p := speaker
	p.stream = load(audio_path)
	p.play()
	
	print("Playing solved sound: ", audio_path)
	
	await p.finished
	emit_signal("sound_over")


func _on_signal_solved():
	signals_solved += 1


func end_day():
	print("PHONE CALL: Time for sleep.")
	GameState.can_sleep = true
	emit_signal("day_completed", day)
	
	# Wait for the player to actually sleep (interact with bed)
	await _wait_for_sleep()
	
	day += 1
	start_day()
	

func _wait_for_sleep():
	player_slept_today = false
	while !player_slept_today:
		await get_tree().process_frame

func player_slept():
	player_slept_today = true
