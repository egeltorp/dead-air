extends Node3D

@onready var knock = $Knock
@onready var face = $Face

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.day_started.connect(_on_day_started)
	_on_day_started(GameManager.day)
	
func _on_day_started(day: int):
	match day:
		1:
			print("Anomaly Day: " + str(day))
			return
		2:
			print("Anomaly Day: " + str(day))
			await get_tree().create_timer(25).timeout
			knock.play()
		3:
			print("Anomaly Day: " + str(day))
			face.visible = true
			await get_tree().create_timer(2).timeout
			$Face/RigidBody3D.freeze = false
			
