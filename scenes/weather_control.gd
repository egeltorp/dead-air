extends Node

@onready var rain = $RainPlayer
@onready var wind = $WindPlayer
@onready var thunder = $ThunderPlayer
@onready var forest = $ForestPlayer
@onready var env = $"../WorldEnvironment".environment

var col_grey = Color("727474")
var col_dark = Color("384156")

func _ready():
	GameManager.day_started.connect(_on_day_started)
	_on_day_started(GameManager.day)


func _on_day_started(day: int):
	_stop_all()

	match day:
		1:
			forest.play()
			print("Weather: Forest")
			env.fog_light_color = col_grey
		
		2:
			wind.play()
			thunder.play()
			print("Weather: Wind + Thunder")
		
		3:
			rain.play()
			forest.play()
			print("Weather: Rain + Forest")
		
		4:
			rain.play()
			wind.play()
			print("Weather: Rain + Wind")
		
		5:
			wind.play()
			rain.play()
			thunder.play()
			env.fog_light_color = col_dark
			print("Weather: Wind + Rain + Thunderstorm")


func _stop_all():
	rain.stop()
	wind.stop()
	thunder.stop()
