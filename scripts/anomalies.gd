extends Node3D

@onready var knock = $Knock
@onready var face = $Face
@onready var howl = $Howl

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
			await get_tree().create_timer(5).timeout
			knock.play()
		4:
			$Doorslam.play()
			$"../Room/Decorations/ak47".queue_free()
			await get_tree().create_timer(35).timeout
			howl.play()
		5:
			$LightBreak.play()
			if $"../Room/CeilingLight".visible == true:
				$"../Room/CeilingLight".visible = false
			$"../Room/LampShade".visible = false
			await get_tree().create_timer(3).timeout
			$FlashlightActivate.play()
			$"../Player/Camera3D/SpotLight3D".visible = true
