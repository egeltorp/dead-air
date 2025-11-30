extends OmniLight3D

@export var min_wait: float = 20.0
@export var max_wait: float = 30.0
@export var flicker_strength: float = 0.6
@export var flicker_speed: float = 0.05
var base_energy: float
var lower_energy: float



func _ready() -> void:
	base_energy = light_energy
	lower_energy = base_energy * 0.75
	_start_flicker_loop()

func _start_flicker_loop() -> void:
	await get_tree().create_timer(randf_range(min_wait, max_wait)).timeout
	_flicker()
	_start_flicker_loop()

func _flicker() -> void:
	$Flicker.play()
	if GameManager.day == 3:
		base_energy = lower_energy
	if GameManager.day == 5:
		base_energy *= 0.9
	
	var pulses := randi_range(2, 5)
	for i in range(pulses):
		var drop := randf() * flicker_strength
		light_energy = base_energy * (1.0 - drop)
		await get_tree().create_timer(flicker_speed).timeout
		light_energy = base_energy
		await get_tree().create_timer(flicker_speed).timeout
