extends OmniLight3D

@export var start_wait: float = 2.0	# seconds before blinking starts
@export var blink_interval: float = 0.5	# how often the light toggles

var base_energy: float
var is_on: bool = true

func _ready() -> void:
	base_energy = light_energy
	_start_blinking()

func _start_blinking() -> void:
	await get_tree().create_timer(start_wait).timeout
	blink_loop()

func blink_loop() -> void:
	while true:
		is_on = !is_on
		light_energy = base_energy if is_on else 0.0
		await get_tree().create_timer(blink_interval).timeout
