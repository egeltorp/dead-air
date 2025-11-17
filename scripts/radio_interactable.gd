extends Interactable

var is_on: bool = false
@onready var audio_source: AudioStreamPlayer3D = $"../../AudioStreamPlayer3D"
@onready var start_volume = audio_source.volume_db

func _ready() -> void:
	audio_source.play()
	radio()

func interact(player): 
	is_on = !is_on
	radio()
	
func radio():
	if is_on:
		audio_source.volume_db = start_volume
	elif !is_on:
		audio_source.volume_db = -80


func get_interact_text() -> String: return "Use Radio"
