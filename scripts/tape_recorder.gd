extends Node3D

@onready var lt: MeshInstance3D = $tape_1
@onready var rt: MeshInstance3D = $tape_1_001

var speed: float = 8 # radians/sec

func _process(delta: float) -> void:
	lt.rotate(Vector3.FORWARD, speed * delta)
	rt.rotate(Vector3.FORWARD, -speed * delta)
	
